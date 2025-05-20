// widgets/profile/form16_modal.dart
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
// --- IMPORT THE NEW PLUGIN ---
import 'package:flutter_pdfview/flutter_pdfview.dart';
// --- Keep other imports ---
import '../../constants/profile/profile_modal_constants.dart';
// Removed 'package:pdf_viewer_plugin/pdf_viewer_plugin.dart';
import 'package:url_launcher/url_launcher.dart';

class Form16Modal extends StatefulWidget {
  final String form16Url;
  const Form16Modal({super.key, required this.form16Url});

  @override
  State<Form16Modal> createState() => _Form16ModalState();
}

class _Form16ModalState extends State<Form16Modal> {
  bool _isLoading = true;
  bool _isDownloading = false;
  String? _pdfPath;
  String? _error;
  double _downloadProgress = 0.0;
  CancelToken _pdfLoadCancelToken = CancelToken();
  int? pages;
  int? currentPage;
  bool isReady = false;
  PDFViewController? _pdfViewController;

  @override
  void initState() {
    super.initState();
    _loadPdf();
  }

  @override
  void dispose() {
    if (!_pdfLoadCancelToken.isCancelled) {
      _pdfLoadCancelToken.cancel("Modal disposed during load");
    }
    super.dispose();
  }

  Future<void> _loadPdf({bool isRetry = false}) async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _isDownloading = false;
      _error = null;
      _pdfPath = null;
      _downloadProgress = 0.0;
      pages = null;
      currentPage = null;
      isReady = false;
      _pdfViewController = null;
      if (!isRetry) {
        _pdfLoadCancelToken = CancelToken();
      } else if (_pdfLoadCancelToken.isCancelled) {
        _pdfLoadCancelToken = CancelToken();
      }
    });

    File? file;
    try {
      final dir = await getTemporaryDirectory();
      final filename =
          'temp_form16_${DateTime.now().millisecondsSinceEpoch}.pdf';
      file = File('${dir.path}/$filename');

      final dio = Dio();
      await dio.download(
        widget.form16Url,
        file.path,
        cancelToken: _pdfLoadCancelToken,
        onReceiveProgress: (received, total) {
          if (total != -1 && mounted) {
            setState(() => _downloadProgress = received / total);
          }
        },
      );

      if (_pdfLoadCancelToken.isCancelled) {
        if (kDebugMode) print("PDF Load cancelled.");
        if (mounted) setState(() => _isLoading = false);
        return;
      }

      if (mounted) {
        setState(() {
          _pdfPath = file?.path;
          _isLoading = false;
          _downloadProgress = 0.0;
        });
      }
    } on DioException catch (e) {
      if (mounted) {
        _setErrorState("Error downloading PDF: ${e.message}");
      }
    } catch (e) {
      if (mounted) {
        _setErrorState("Unexpected error: $e");
      }
    }
  }

  void _setErrorState(String message) {
    if (mounted) {
      setState(() {
        _error = message;
        _isLoading = false;
        _isDownloading = false;
        _pdfPath = null;
        pages = null;
        currentPage = null;
        _downloadProgress = 0.0;
      });
    }
  }

  Future<void> _downloadForm16() async {
    if (_pdfPath == null) return;

    setState(() {
      _isDownloading = true;
      _downloadProgress = 0.0;
    });

    try {
      final dir = await getApplicationDocumentsDirectory();
      final filename = 'Form16_${DateTime.now().millisecondsSinceEpoch}.pdf';
      final savedFile = await File(_pdfPath!).copy('${dir.path}/$filename');

      if (mounted) {
        setState(() {
          _isDownloading = false;
          _downloadProgress = 0.0;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Form 16 saved to ${savedFile.path}'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        _setErrorState("Error saving PDF: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool canDownload = !_isLoading && _pdfPath != null && !_isDownloading;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ModalConstants.modalBorderRadius),
      ),
      elevation: ModalConstants.modalElevation,
      child: ModalConstants.buildModalContainer(context, [
        ModalConstants.buildModalHeader(
          context,
          'Form 16',
          onClose: () {
            if (!_pdfLoadCancelToken.isCancelled) {
              _pdfLoadCancelToken.cancel("User closed modal via header");
            }
            Navigator.pop(context);
          },
        ),
        const Divider(height: 1, thickness: 1),
        Flexible(
          child: Padding(
            padding: ModalConstants.contentPadding,
            child: _buildContentArea(context, theme),
          ),
        ),
        Padding(
          padding: ModalConstants.modalPadding.copyWith(
            top: ModalConstants.modalSpacing,
          ),
          child: ElevatedButton.icon(
            onPressed: canDownload ? _downloadForm16 : null,
            style: ModalConstants.elevatedButtonStyle(context),
            icon:
                _isDownloading
                    ? SizedBox(
                      width: ModalConstants.buttonIconSize,
                      height: ModalConstants.buttonIconSize,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        value: _downloadProgress > 0 ? _downloadProgress : null,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          theme.colorScheme.onPrimary,
                        ),
                      ),
                    )
                    : const Icon(
                      Icons.download_outlined,
                      size: ModalConstants.buttonIconSize,
                    ),
            label: Text(_isDownloading ? 'Downloading...' : 'Download Form 16'),
          ),
        ),
      ]),
    );
  }

  Widget _buildContentArea(BuildContext context, ThemeData theme) {
    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              value: _downloadProgress > 0 ? _downloadProgress : null,
            ),
            const SizedBox(height: 16),
            Text('Loading Form 16...', style: theme.textTheme.bodyLarge),
            if (_downloadProgress > 0)
              Text(
                '${(_downloadProgress * 100).toStringAsFixed(1)}%',
                style: theme.textTheme.bodyMedium,
              ),
          ],
        ),
      );
    } else if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: theme.colorScheme.error),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  _error!,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge,
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _loadPdf(isRetry: true),
              child: const Text('Retry'),
            ),
            ElevatedButton.icon(
              onPressed: () async {
                final url = Uri.parse(widget.form16Url);
                if (await canLaunchUrl(url)) {
                  await launchUrl(url, mode: LaunchMode.externalApplication);
                }
              },
              icon: Icon(Icons.open_in_browser),
              label: Text('Open in Browser'),
            ),
          ],
        ),
      );
    } else if (_pdfPath != null) {
      return PDFView(
        filePath: _pdfPath!,
        enableSwipe: true,
        swipeHorizontal: false,
        autoSpacing: false,
        pageFling: true,
        pageSnap: true,
        defaultPage: currentPage ?? 0,
        fitPolicy: FitPolicy.BOTH,
        preventLinkNavigation: false,
        onError: (error) {
          if (mounted) {
            _setErrorState(
              "Error displaying PDF: $error.\nPlease try reloading.",
            );
          }
          if (kDebugMode) print(error.toString());
        },
        onRender: (pagesArg) {
          if (mounted) {
            setState(() {
              pages = pagesArg;
              isReady = true;
            });
            if (kDebugMode) print("PDF Rendered: $pagesArg pages");
          }
        },
        onViewCreated: (PDFViewController pdfViewController) {
          if (mounted && _pdfViewController == null) {
            setState(() {
              _pdfViewController = pdfViewController;
            });
          }
        },
        onPageChanged: (int? page, int? total) {
          if (mounted && page != null && total != null) {
            setState(() => currentPage = page);
            if (kDebugMode) print('page change: ${page + 1}/$total');
          }
        },
        onPageError: (page, error) {
          if (mounted) {
            _setErrorState("Error loading page $page: $error");
          }
          if (kDebugMode) print('$page: ${error.toString()}');
        },
      );
    } else {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.warning_amber_rounded,
              size: 48,
              color: theme.colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text('Unable to load Form 16', style: theme.textTheme.bodyLarge),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _loadPdf(isRetry: true),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }
  }
}

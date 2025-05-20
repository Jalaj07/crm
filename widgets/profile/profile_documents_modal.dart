// widgets/profile/documents_modal.dart
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../constants/profile/profile_modal_constants.dart';

// Keep DocumentItem class defined or imported
class DocumentItem {
  /* ... DocumentItem definition ... */
  final String name;
  final String description;
  final String url;
  final IconData icon;
  final Color color;

  DocumentItem({
    required this.name,
    required this.description,
    required this.url,
    required this.icon,
    required this.color,
  });
}

class DocumentsModal extends StatelessWidget {
  final String modalTitle;
  final List<DocumentItem> documents;

  const DocumentsModal({
    super.key,
    required this.documents,
    this.modalTitle = 'My Documents',
  });

  String _convertToDirectDownloadUrl(String url) {
    if (url.isEmpty) return url;

    // Check if it's a Google Drive URL
    RegExp driveRegex = RegExp(
      r'https://drive\.google\.com/file/d/([^/]+)/view',
    );
    var match = driveRegex.firstMatch(url);

    if (match != null) {
      String fileId = match.group(1)!;
      return 'https://drive.google.com/uc?export=download&id=$fileId';
    }

    return url;
  }

  Future<void> _viewDocument(
    BuildContext context,
    DocumentItem document,
  ) async {
    final downloadUrl = _convertToDirectDownloadUrl(document.url);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => DocumentViewerDialog(
            document: document,
            downloadUrl: downloadUrl,
          ),
    );
  }

  Future<void> _downloadDocument(
    BuildContext context,
    DocumentItem document,
  ) async {
    final downloadUrl = _convertToDirectDownloadUrl(document.url);
    final messenger = ScaffoldMessenger.of(context);

    try {
      final dir = await getApplicationDocumentsDirectory();
      final filename =
          '${document.name}_${DateTime.now().millisecondsSinceEpoch}.pdf';
      final filePath = '${dir.path}/$filename';

      await Dio().download(
        downloadUrl,
        filePath,
        onReceiveProgress: (received, total) {
          if (total != -1 && context.mounted) {
            final progress = (received / total * 100).toStringAsFixed(0);
            messenger.showSnackBar(
              SnackBar(
                content: Text('Downloading: $progress%'),
                duration: const Duration(milliseconds: 500),
              ),
            );
          }
        },
      );

      if (context.mounted) {
        messenger.showSnackBar(
          SnackBar(
            content: Text('${document.name} downloaded successfully'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        messenger.showSnackBar(
          SnackBar(
            content: Text('Error downloading document: ${e.toString()}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ModalConstants.modalBorderRadius),
      ),
      elevation: ModalConstants.modalElevation,
      child: ModalConstants.buildModalContainer(context, [
        ModalConstants.buildModalHeader(context, modalTitle),
        const Divider(height: 1, thickness: 1),

        // Conditional Content: Either list or empty state
        documents.isEmpty
            ? // Use the Empty State helper
            ModalConstants.buildEmptyState(
              context,
              Icons.folder_off_outlined, // Suitable icon for documents
              'No documents found.',
            )
            : // Use Flexible + ListView for scrollable content when needed
            Flexible(
              // Allows ListView to take space but not necessarily expand fully
              child: ListView.builder(
                shrinkWrap:
                    true, // Allows listview to take only needed vertical space
                padding: ModalConstants.contentPadding, // Consistent padding
                itemCount: documents.length,
                itemBuilder: (context, index) {
                  final document = documents[index];
                  return Card(
                    // Updated Card properties to match Knowledge Base style
                    elevation: 2, // Matches _buildMediaCard elevation
                    margin: const EdgeInsets.only(
                      bottom: 12,
                    ), // Matches _buildFaqCard/IssueCard margin
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        8,
                      ), // Matches _buildMediaCard border radius
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(
                        8,
                      ), // Add padding around the content
                      child: Row(
                        children: [
                          // Updated Left Icon Container
                          Container(
                            width: 60,
                            height: 60, // Give it a fixed height
                            decoration: BoxDecoration(
                              color:
                                  Colors
                                      .grey[100], // Matches _buildMediaCard color
                              borderRadius: BorderRadius.circular(
                                8,
                              ), // Matches _buildMediaCard border radius
                            ),
                            child: Center(
                              child: Icon(
                                Icons
                                    .picture_as_pdf, // Use the same icon as _buildMediaCard
                                size: 32,
                                color:
                                    Colors
                                        .red[400], // Use the same color as _buildMediaCard
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 12,
                          ), // Spacing between icon and text/buttons
                          // Expanded Column for Title, Description, and Buttons
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment:
                                  MainAxisAlignment
                                      .center, // Center content vertically
                              children: [
                                Text(
                                  document.name,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontSize:
                                        14, // Adjust font size to match _buildMediaCard
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                // Add the description text
                                const SizedBox(
                                  height: 4,
                                ), // Spacing between title and description
                                Text(
                                  document.description,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    // Use a smaller style
                                    color:
                                        theme
                                            .colorScheme
                                            .onSurfaceVariant, // Use a suitable color
                                  ),
                                  maxLines:
                                      2, // Allow up to 2 lines for description
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(
                                  height: 8,
                                ), // Spacing between description and buttons
                                // Row for View and Download buttons
                                Row(
                                  children: [
                                    // View Button
                                    Expanded(
                                      // Use Expanded to make buttons take available space
                                      child: ElevatedButton.icon(
                                        onPressed:
                                            () => _viewDocument(
                                              context,
                                              document,
                                            ),
                                        icon: const Icon(
                                          Icons.visibility_outlined,
                                          size: 18,
                                        ), // Use a suitable icon
                                        label: const Text(
                                          'View',
                                          style: TextStyle(
                                            fontSize: 12,
                                          ), // Adjust font size
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 8,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              6,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ), // Smaller spacing between buttons
                                    // Download Button
                                    Expanded(
                                      // Use Expanded to make buttons take available space
                                      child: ElevatedButton.icon(
                                        onPressed:
                                            () => _downloadDocument(
                                              context,
                                              document,
                                            ),
                                        icon: const Icon(
                                          Icons.file_download,
                                          size: 18,
                                        ), // Use download icon
                                        label: const Text(
                                          'Download',
                                          style: TextStyle(
                                            fontSize: 12,
                                          ), // Adjust font size
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 8,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              6,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
        // Ensure some bottom padding inside the modal if needed
        const SizedBox(height: ModalConstants.modalSpacing),
      ]),
    );
  }
}

class DocumentViewerDialog extends StatefulWidget {
  final DocumentItem document;
  final String downloadUrl;

  const DocumentViewerDialog({
    super.key,
    required this.document,
    required this.downloadUrl,
  });

  @override
  State<DocumentViewerDialog> createState() => _DocumentViewerDialogState();
}

class _DocumentViewerDialogState extends State<DocumentViewerDialog> {
  bool _isLoading = true;
  String? _pdfPath;
  String? _error;
  double _downloadProgress = 0.0;
  CancelToken _cancelToken = CancelToken();
  int? pages;
  int? currentPage;
  bool isReady = false;

  @override
  void initState() {
    super.initState();
    _loadPdf();
  }

  @override
  void dispose() {
    if (!_cancelToken.isCancelled) {
      _cancelToken.cancel("Dialog disposed");
    }
    super.dispose();
  }

  Future<void> _loadPdf({bool isRetry = false}) async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _error = null;
      _pdfPath = null;
      _downloadProgress = 0.0;
      pages = null;
      currentPage = null;
      isReady = false;
      if (isRetry && !_cancelToken.isCancelled) {
        _cancelToken = CancelToken();
      }
    });

    try {
      final dir = await getTemporaryDirectory();
      final filename = 'temp_doc_${DateTime.now().millisecondsSinceEpoch}.pdf';
      final file = File('${dir.path}/$filename');

      await Dio().download(
        widget.downloadUrl,
        file.path,
        cancelToken: _cancelToken,
        onReceiveProgress: (received, total) {
          if (total != -1 && mounted) {
            setState(() => _downloadProgress = received / total);
          }
        },
      );

      if (_cancelToken.isCancelled) {
        if (kDebugMode) print("PDF Load cancelled.");
        return;
      }

      if (mounted) {
        setState(() {
          _pdfPath = file.path;
          _isLoading = false;
          _downloadProgress = 0.0;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = "Error loading PDF: ${e.toString()}";
          _isLoading = false;
          _downloadProgress = 0.0;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ModalConstants.modalBorderRadius),
      ),
      elevation: ModalConstants.modalElevation,
      child: ModalConstants.buildModalContainer(context, [
        ModalConstants.buildModalHeader(
          context,
          widget.document.name,
          onClose: () {
            if (!_cancelToken.isCancelled) {
              _cancelToken.cancel("User closed dialog");
            }
            Navigator.pop(context);
          },
        ),
        const Divider(height: 1, thickness: 1),
        Expanded(child: _buildContent(theme)),
      ]),
    );
  }

  Widget _buildContent(ThemeData theme) {
    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              value: _downloadProgress > 0 ? _downloadProgress : null,
            ),
            const SizedBox(height: 16),
            Text('Loading document...', style: theme.textTheme.bodyLarge),
            if (_downloadProgress > 0)
              Text(
                '${(_downloadProgress * 100).toStringAsFixed(1)}%',
                style: theme.textTheme.bodyMedium,
              ),
          ],
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: theme.colorScheme.error),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                _error!,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _loadPdf(isRetry: true),
              child: const Text('Retry'),
            ),
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: () async {
                final url = Uri.parse(widget.downloadUrl);
                if (await canLaunchUrl(url)) {
                  await launchUrl(url, mode: LaunchMode.externalApplication);
                }
              },
              icon: const Icon(Icons.open_in_browser),
              label: const Text('Open in Browser'),
            ),
          ],
        ),
      );
    }

    if (_pdfPath != null) {
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
            setState(() {
              _error = "Error displaying PDF: $error";
            });
          }
        },
        onRender: (pages) {
          if (mounted) {
            setState(() {
              this.pages = pages;
              isReady = true;
            });
          }
        },
        onViewCreated: (PDFViewController pdfViewController) {
          if (mounted) {
            setState(() {});
          }
        },
        onPageChanged: (int? page, int? total) {
          if (mounted && page != null) {
            setState(() => currentPage = page);
          }
        },
        onPageError: (page, error) {
          if (mounted) {
            setState(() {
              _error = "Error loading page $page: $error";
            });
          }
        },
      );
    }

    return const Center(child: Text('No document available'));
  }
}

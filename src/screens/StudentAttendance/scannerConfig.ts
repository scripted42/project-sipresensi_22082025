// Scanner configuration and helper functions
export const SCANNER_CONFIG = {
  // Supported barcode types
  SUPPORTED_TYPES: [
    'qr',
    'ean13',
    'ean8',
    'code128',
    'code39'
  ],
  
  // Scanner settings
  SCAN_SETTINGS: {
    interval: 500, // Scan interval in milliseconds
    vibrate: true // Vibrate on successful scan
  },
  
  // UI settings
  UI_SETTINGS: {
    showViewFinder: true,
    viewFinder: {
      backgroundColor: 'rgba(0, 0, 0, 0.5)',
      borderColor: '#007AFF',
      borderWidth: 2,
      borderLength: 30,
      height: 200,
      width: 200
    }
  }
};

// Helper function to validate scanned data
export const validateQRData = (data: string): boolean => {
  // Check if data is not empty
  if (!data || data.trim().length === 0) {
    return false;
  }
  
  // Check if data is a valid URL or contains valid QR data format
  // You can customize this validation based on your QR code format
  return true;
};

// Helper function to format error messages
export const formatScannerError = (error: any): string => {
  if (error.message) {
    return error.message;
  }
  
  if (typeof error === 'string') {
    return error;
  }
  
  return 'Unknown error occurred during scanning';
};
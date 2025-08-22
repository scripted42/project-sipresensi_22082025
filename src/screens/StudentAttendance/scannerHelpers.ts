// Scanner helper functions

// Validate scanned QR data
export const validateQRData = (data: string): boolean => {
  // Check if data is not empty
  if (!data || data.trim().length === 0) {
    return false;
  }
  
  // Check if data matches expected format (you can customize this)
  // For example, if QR codes should be numeric:
  // return /^\d+$/.test(data);
  
  // For now, we'll just check that it's not empty
  return true;
};

// Format error messages
export const formatScannerError = (error: any): string => {
  if (error.message) {
    return error.message;
  }
  
  if (typeof error === 'string') {
    return error;
  }
  
  return 'Unknown error occurred during scanning';
};

// Scanner configuration
export const SCANNER_CONFIG = {
  // Supported barcode types
  SUPPORTED_TYPES: [
    'qr',
  ],
  
  // Scanner settings
  SCAN_SETTINGS: {
    interval: 1000, // Scan interval in milliseconds (1 second)
    vibrate: true // Vibrate on successful scan
  },
  
  // UI settings
  UI_SETTINGS: {
    viewFinder: {
      borderColor: '#007AFF',
      borderWidth: 2,
      height: 250,
      width: 250
    }
  }
};
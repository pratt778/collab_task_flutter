extension NepaliNumberConverter on String {
  String toNepali() {
    const map = {
      '0': '०',
      '1': '१',
      '2': '२',
      '3': '३',
      '4': '४',
      '5': '५',
      '6': '६',
      '7': '७',
      '8': '८',
      '9': '९',
    };
    return toString().split('').map((c) => map[c] ?? c).join();
  }
}

// Usage:
// "2082".toNepali(); 
// 9841.toNepali();
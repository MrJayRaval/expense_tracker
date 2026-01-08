This script helps generate an HTML coverage report for the Flutter project.

Usage:

1. Ensure Flutter is installed and available in PATH.
2. Ensure `lcov` (genhtml) is installed. On Debian/Ubuntu: `sudo apt install lcov`.
3. From the project root run:

   ./scripts/generate_coverage.sh

This will run `flutter test --coverage` and then run `genhtml coverage/lcov.info -o coverage/html`.

Open `coverage/html/index.html` in your browser to view the report.

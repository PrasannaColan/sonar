const fs = require('fs');
const path = require('path');
const lcovParse = require('lcov-parse');

// Define the output directory and file
const outputDir = 'build/reports/jacoco/test/';
const outputFile = 'jacocoTestReport.xml';

// Ensure the directory exists
fs.mkdirSync(outputDir, { recursive: true });

lcovParse('coverage/lcov.info', (err, data) => {
  if (err) {
    console.error('Error parsing LCOV file:', err);
    return;
  }

  let jacocoXml = '<?xml version="1.0" encoding="UTF-8"?>\n<report name="lcov-to-jacoco">\n';

  data.forEach(entry => {
    jacocoXml += `  <package name="${entry.file.replace(/\//g, '.')}">\n`;
    entry.lines.details.forEach(line => {
      jacocoXml += `    <lineToCover lineNumber="${line.line}" covered="${line.hit > 0}" />\n`;
    });
    jacocoXml += '  </package>\n';
  });

  jacocoXml += '</report>\n';

  fs.writeFileSync(path.join(outputDir, outputFile), jacocoXml);
  console.log('JaCoCo XML report generated successfully at', path.join(outputDir, outputFile));
});

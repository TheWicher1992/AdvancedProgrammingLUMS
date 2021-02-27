const fs = require(`fs`)

const copyFiles = (srcFiles, destDir, callback) => {
  let filesLeft = srcFiles.length;
  srcFiles.forEach((fileName) => {
    fs.readFile(fileName, (readErr, fileContents) => {
      if (readErr) {
        console.log(`Reading ${fileName} ${readErr}`)
        if (--filesLeft == 0) {
          callback()
        }
      } else {
        console.log(`${fileName} read, initiating write`)
        fs.writeFile(`${destDir}/${fileName}`, fileContents, (writeErr) => {
          if (writeErr) {
            console.log(`Writing ${fileName} ${writeErr}`)
          } else {
            console.log(`${fileName} written`)
          }
          if (--filesLeft == 0) {
            callback()
          }
        })
      }
    })
  })
}

copyFiles([`a.txt`, `b.txt`, `c.txt`], `dest`, () => {
  console.log(`All done.`)
})

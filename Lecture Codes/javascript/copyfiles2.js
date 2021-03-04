const fs = require(`fs`)

const readFile = (fileName) =>
  new Promise((resolve, reject) => {
    fs.readFile(fileName, (readErr, fileContents) => {
      if (readErr) {
        reject(readErr)
      } else {
        resolve(fileContents)
      }
    })
  })

const writeFile = (fileName, fileContents) =>
  new Promise((resolve, reject) => {
    fs.writeFile(fileName, fileContents, (writeErr) => {
      if (writeErr) {
        reject(writeErr)
      } else {
        resolve()
      }
    })
  })

const copyFiles = (srcFiles, destDir) =>
  Promise.all(srcFiles.map((fileName) =>
    readFile(fileName)
      .then((fileContents) => {
        console.log(`${fileName} read, initiating write`)
        return writeFile(`${destDir}/${fileName}`, fileContents)
      })
      .then(() => {
        console.log(`${fileName} written`)
      })
      .catch(err => {
        console.log(`Error processing ${fileName} ${err}`)
      })
  ))

copyFiles([`a.txt`, `b.txt`, `c.txt`], `dest`).then(() => {
  console.log(`All done.`)
})


// const allDone = new Promise((resolve) => {
//   let filesLeft = srcFiles.length;
//   promises.forEach((p) => {
//     p.then(() => {
//       if (--filesLeft == 0) {
//         resolve()
//       }
//     }).catch(() => {
//       if (--filesLeft == 0) {
//         resolve()
//       }
//     })
//   })  
// })

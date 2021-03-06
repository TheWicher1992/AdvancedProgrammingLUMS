const fs = require('fs')
const path = require('path')

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


const readDir = (path) =>
    new Promise((resolve, reject) => {
        fs.readdir(path, (err, files) => {
            if (err) {
                reject(err)
            }
            else {
                resolve(files)
            }
        })
    })

const mkdir = (path) =>
    new Promise((resolve, reject) => {
        fs.mkdir(path, (err) => {
            if (err) {
                reject(err)
            }
            else {
                resolve()
            }
        })
    })

const lstat = (path) =>
    new Promise((resolve, reject) => {
        fs.lstat(path, (err, stats) => {
            if (err) {
                reject(err)
            }
            else {
                resolve(stats)
            }
        })
    })

const copyFile = (srcFile, destDir) =>
    Promise.all([srcFile].map((fileName) =>
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


const copydir = async (srcPath, dstPath) => {
    try {
        const dir = await readDir(srcPath)
        try {
            await mkdir(__dirname + `/${dstPath}`)
            return Promise.all(dir.map(async (file) => {
                const fileName = __dirname + `/${srcPath}/${file}`
                try {
                    const stat = await lstat(fileName)
                    if (!stat.isDirectory()) {
                        try {
                            const fileContents = await readFile(srcPath + `/${file}`)
                            try {
                                await writeFile(dstPath + `/${file}`, fileContents)

                            } catch (error) {
                                console.log('Error while writing', error.code)
                            }
                        } catch (error) {
                            console.log('Error while reading', error.code)
                        }

                    }
                    else {
                        copydir(srcPath + `/${file}`, dstPath + `/${file}`)
                    }
                } catch (error) {
                    console.log('Error occured')
                }

            }))
        }
        catch (err) {
            console.log('Error while making new directory', err.code)
        }

    } catch (err) {
        console.log('Error while reading directory.', err.code)
    }


}

copydir('dest', 'sameer').then(() => console.log('All done'))

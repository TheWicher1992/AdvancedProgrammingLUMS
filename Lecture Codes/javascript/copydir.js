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


const copydir = async (srcPath, dstPath) => {
    try {
        const dir = await readDir(srcPath)
        await mkdir(__dirname + `/${dstPath}`)
        Promise.all(dir.map(async (file) => {
            const fileName = __dirname + `/${srcPath}/${file}`
            const stat = await lstat(fileName)
            if (!stat.isDirectory()) {
                const fileContents = await readFile(srcPath + `/${file}`)
                await writeFile(dstPath + `/${file}`, fileContents)
            }
            else {
                copydir(srcPath + `/${file}`, dstPath + `/${file}`)
            }

        }))
    } catch (err) {
        console.log('The operation failed', err.code)
    }


}

//copydir('sameer', 'sameer2').then(() => console.log('All done'))

require('dotenv').config();
const express = require('express');
const cors = require("cors")
const https = require('https')
const fs = require("fs")
const redisClient = require("./app/databases/redis")
const db = require("./app/databases/postgres")

const app = express()
const PORT = process.env.PORT

app.use(express.json());
app.use(express.urlencoded({extended:true}));
app.use(cors())

const util = require('util');
const exec = util.promisify(require('child_process').exec);

app.get("/infos", async (req, res) => {

  const id = await exec('hostname');
  const ip = await exec('hostname -i');
  if(id.stderr || ip.stderr) return res.json("error")
  
  res.json({id: id.stdout.slice(0, -1), ip: ip.stdout.slice(0, -1)})
    
})

app.get("/seeding", async (req, res) => {

  try {
    const {rows} = await db.query('SELECT * FROM "offer"')
    
    res.json(rows)
  } catch (error) {
    res.json(error.message)
  }
    
})

app.get("/sqitch", async (req, res) => {

  try {
    const {rows} = await db.query('SELECT * FROM "offer"')
    
    res.json(`there is no sql error, it mean sqitch deploy it works ${rows}`)
  } catch (error) {
    res.json(error.message)
  }
    
})

let certFiles;
if(process.env.NODE_ENV === "production"){
  certFiles = {
    key: fs.readFileSync("./ssl/privkey.pem"),
    cert: fs.readFileSync("./ssl/fullchain.pem")
  };
}

  if(process.env.NODE_ENV === "production") https.createServer(certFiles, app).listen(PORT, () => console.log(`HTTPS server up, listen on port: ${PORT}`));
  else app.listen(PORT, () => console.log(`HTTP server up, listen on port: ${PORT}`));







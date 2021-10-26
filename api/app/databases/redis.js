const redis = require('redis');


const client = redis.createClient(process.env.REDIS_URL)

client.GET("ping", (err, data) => {
  if(err) console.log(err)
  console.log('redis database connected')
})

client.on("error", (error) => {
    console.log(error)
});

client.inc

module.exports = client

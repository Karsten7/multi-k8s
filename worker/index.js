// get connection keys
const keys = require('./keys');
// import redis client
const redis = require('redis');

// create a redis client
const redisClient = redis.createClient({
  host: keys.redisHost,
  port: keys.redisPort,
  retry_strategy: () => 1000
});

// make a duplicate of this redis client
const sub = redisClient.duplicate();

// recursive work function to calculate the fibonacci number based on its index
function fib(index) {
  if (index < 2) return 1;
  return fib(index - 1) + fib(index - 2);
}

// watch redis for new value (new message), calculate new value, and insert it into hash called values
sub.on('message', (channel, message) => {
  redisClient.hset('values', message, fib(parseInt(message)));
});
// subscribe to insert event (new value inserted into redis -> get that value -> calculate the fibonacci number for it -> toss it back to redis instance)
sub.subscribe('insert');
every 1.day do
  rake 'st:overview'
  rake 'st:retention'
  rake 'st:hit'
  rake 'st:online'
  rake 'mob:access_token'
end
every 1.hour do
  rake 'rank:week'
end

every 1.day do
  rake 'rank:month'
end

every 30.minutes do
  rake 'course:check'
end


every 1.day do
  rake 'st:overview'
  rake 'st:retention'
  rake 'st:hit'
  rake 'st:online'
end

every 1.hour do
  rake 'rank:week'
end

every 1.day do
  rake 'rank:month'
end
every 1.minute do
  rake 'st:overview'
end

every 1.hour do
  rake 'rank:week'
end

every 1.day do
  rake 'rank:month'
end
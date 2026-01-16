Sqlite3Rsync.configure do |config|
  config.sync_on_write = true
  config.write_debounce_seconds = 2
  config.interval = 30
end

INTERESTS = YAML.load_file("#{Rails.root}/config/deploy_config/interests.yml")
CITIES = JSON.parse(File.read("#{Rails.root}/config/locales/city.json"))
VERSION = YAML.load_file("#{Rails.root}/config/deploy_config/version.yml")
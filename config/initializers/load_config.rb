INTERESTS = YAML.load_file("#{Rails.root}/config/deploy_config/interests.yml")
VERSION = YAML.load_file("#{Rails.root}/config/deploy_config/version.yml")
MOB = YAML.load_file("#{Rails.root}/config/deploy_config/mob.yml")['stage']
MESSAGE = YAML.load_file("#{Rails.root}/config/deploy_config/message.yml")
# encoding: utf-8

keyword_category = KeywordCategory.create(name: 'Pôles de compétence')

[ "ACAI",
  "Bases de données",
  "Messagerie",
  "Virtualisation",
  "Stockage",
  "Système",
  "Industrialisation",
  "Supervision",
  "Sauvegarde",
  "Sécurité",
  "Infrastructure",
  "Documentation",
  "Formations",
  "Pilotage"
].each do |keyword_name|
  Keyword.create(name: keyword_name, keyword_category: keyword_category)
end


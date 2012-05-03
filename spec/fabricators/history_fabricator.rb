# encoding: UTF-8

Fabricator(:history, class_name: :history) do
  user!(fabricator: :user)
  subject!(fabricator: :sheet)
  action 'create'
end

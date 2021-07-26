Bookmark.blueprint(:sobrinho) do
  user  { User.make!(:sobrinho_as_admin) }
  links { [Link.make!(:users), Link.make!(:profiles)] }
end

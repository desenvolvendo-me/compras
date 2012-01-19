Bookmark.blueprint(:sobrinho) do
  user  { User.make!(:sobrinho_as_admin) }
  links { [Link.make!(:cities), Link.make!(:countries)] }
end

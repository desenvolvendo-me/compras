Bookmark.blueprint(:sobrinho) do
  user  { User.make!(:sobrinho) }
  links { [Link.make!(:cities), Link.make!(:countries)] }
end

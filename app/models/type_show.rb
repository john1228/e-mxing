class TypeShow < News
  default_scope { where(tag: News::TAG[2]) }
end

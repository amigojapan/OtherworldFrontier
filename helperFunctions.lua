function isInteger(str)

    return not (str == "" or str:find("%D"))  -- str:match("%D") also works
  
end

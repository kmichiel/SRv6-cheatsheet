-- prepend a slash to all image paths
function Image (img)
  img.src = '/' .. img.src
  return IMG
end

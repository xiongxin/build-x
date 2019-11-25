import parseutils

echo 'c'
let a = "\r\n" 
echo '\n' == '\l'
echo '\r' == '\c'
echo cast[int]('\n')
echo cast[int]('\l')

echo cast[int]('\r')
echo cast[int]('\c')


echo skipWhitespace("Hello World", 0)
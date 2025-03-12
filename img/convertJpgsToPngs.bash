find . -name "*.jpg" -exec mogrify -format png {} \;
rm *.jpg
find . -name "*.jpeg" -exec mogrify -format png {} \;
rm *.jpeg

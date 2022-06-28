cd ./www
echo 'Start deploying'
echo $EB_APP 
echo $AWS_DEFAULT_REGION
eb init $EB_APP --region $AWS_DEFAULT_REGION --platform node.js
eb use $EB_ENV
echo $EB_ENV
echo 'set evn variables'
eb setenv POSTGRES_USERNAME=$POSTGRES_USERNAME POSTGRES_PASSWORD=$POSTGRES_PASSWORD POSTGRES_DB=$POSTGRES_DB PORT=$PORT POSTGRES_HOST=$POSTGRES_HOST AWS_DEFAULT_REGION=$AWS_DEFAULT_REGION URL=$URL JWT_SECRET=$JWT_SECRET
echo 'Arch app'
zip -r Archive.zip .
echo 'deploy'
eb deploy
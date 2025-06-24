Remove-Item ..\assets\webapp\* -Recurse -Confirm:$false
flutter build web --base-href="/l2s/"
Move-Item .\build\web\* ..\assets\webapp\
# nft
Flutter Template

## Structure

```
                                                     
     main.dart                                       
         |                                           
 +-------|------+                                    
 |     login     |                                    
 +--------------+                                    
 - Login with fake api                                    
         |                                           
 +-------|------+                                    
 |     home     |                                    
 +--------------+                                    
 - Show repo info                                    
 - Navigate to search screen                         
         |                                           
         |                                           
 +-------|------+                                    
 |    search    |                                    
 +--------------+                                    
 - Search github user                                
 - Show a list of user                               
 - Tap on specific user and navigate to detail screen
         |                                           
         |                                           
 +-------|------+                                    
 |    detail    |                                    
 +--------------+                                    
 - Show detail of github user                        

```

## Update app icon

```
flutter pub get
flutter pub run flutter_launcher_icons:main
```
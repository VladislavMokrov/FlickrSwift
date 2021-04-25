# FlickrSwift

The app for viewing photos from the Flickr website
The app consists of three screens:

1. Popular Tags screen
The screen shows a list of popular Flickr site tags
To implement the list, use UITableView

2. Thumbnail screen by tag
The screen shows thumbnails of photos of the Flickr site by a specific tag. To implement the screen, use UICollectionView (in the cell-UIImageView)

3. Full-screen photo view screen
The screen displays a full-screen photo of the selected thumbnail.

Each screen is filled with information received from the server:
Opened the screen -> Request (s) to the server -> Display the received information on the screen
View Layer Architecture - MVC
Networking - URLSession
Grand Central Dispatch is used for working with threads
The data format when interacting with the server is JSON
Tested on iPad / iPhone simulators, with a change of orientation of the device

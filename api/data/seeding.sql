BEGIN;

INSERT INTO "location" ("name", "picture") VALUES
('Alpes du Nord', 'https://images.unsplash.com/photo-1597216394928-e6bc38109801?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=2338&q=80'),
('Alpes du Sud', 'https://images.unsplash.com/photo-1594629706083-67fd4ea4f0d5?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=2340&q=80'),
('Jura', 'https://images.unsplash.com/photo-1603445125995-6f47a1bfccf0?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=2340&q=80'),
('Massif Central', 'https://images.unsplash.com/photo-1603121494413-0d31fe0bfb1e?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=2340&q=80'),
('Pyrennées', 'https://images.unsplash.com/photo-1538427144912-31de1ccb39f2?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2340&q=80'),
('Vosges', 'https://images.unsplash.com/photo-1604782101560-b1cf32c445a8?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=2340&q=80');

INSERT INTO "offer" (
    "title", 
    "body", 
    "zip_code", 
    "city_name", 
    "country", 
    "street_name", 
    "street_number", 
    "price_ht", 
    "tax", 
    "main_picture", 
    "galery_picture_1", 
    "galery_picture_2", 
    "galery_picture_3", 
    "galery_picture_4", 
    "galery_picture_5",
    "location_id"
) VALUES
(
    'La Perle des Bois', 
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse feugiat, lectus eu placerat mattis, nisl enim consequat leo, a ultrices dui nunc ac arcu. Pellentesque luctus diam vitae ligula mollis tempor. Aliquam vestibulum libero quis nisl dapibus venenatis. Nulla facilisi. In ac cursus dolor, eget fermentum sem. Phasellus facilisis sagittis justo eget pellentesque. Fusce eu luctus nulla, et tristique tortor. Vestibulum blandit felis ac lectus fermentum, ac cursus libero elementum. Donec euismod odio tortor, at porttitor massa rutrum sed.', 
    '88400', 
    'Gérardmer', 
    'France', 
    'impasse du Bas cellet', 
    '15', 
    2400, 
    30, 
    'https://scontent-cdg2-1.xx.fbcdn.net/v/t31.18172-8/23415491_129939911054712_866781972381791713_o.jpg?_nc_cat=111&ccb=1-5&_nc_sid=e3f864&_nc_ohc=ktQf7c5Y8KAAX-RwHXQ&_nc_ht=scontent-cdg2-1.xx&oh=46fdc9f458a7d4002a21f9de5078aada&oe=617031D4', 
    'https://scontent-cdt1-1.xx.fbcdn.net/v/t1.6435-9/62135118_352386225476745_1337313070623490048_n.jpg?_nc_cat=106&ccb=1-5&_nc_sid=cdbe9c&_nc_ohc=lmyd3n0k7W4AX-2DrG4&_nc_ht=scontent-cdt1-1.xx&oh=49bbd6291bd20391f622922425d6435c&oe=617CB998', 
    'https://scontent-cdt1-1.xx.fbcdn.net/v/t31.18172-8/23467352_129931997722170_1099338796449142264_o.jpg?_nc_cat=109&ccb=1-5&_nc_sid=cdbe9c&_nc_ohc=fp4K7z9uqVMAX9TlLr5&_nc_ht=scontent-cdt1-1.xx&oh=e0ee4632adfedd652c5fa8d19ff322fc&oe=6170A36A', 
    'https://scontent-cdt1-1.xx.fbcdn.net/v/t31.18172-8/23456221_129931591055544_1784488383432218515_o.jpg?_nc_cat=106&ccb=1-5&_nc_sid=cdbe9c&_nc_ohc=Eu236hV0dowAX8YwSNj&tn=cPe0m3zPJWJoVRzC&_nc_ht=scontent-cdt1-1.xx&oh=a4a91d54e76c98aa37bf8580da9419c7&oe=616FB273', 
    'https://scontent-cdg2-1.xx.fbcdn.net/v/t31.18172-8/23511296_129931734388863_7915502139369921643_o.jpg?_nc_cat=108&ccb=1-5&_nc_sid=cdbe9c&_nc_ohc=zGmBg7gZfxQAX9VItrS&_nc_ht=scontent-cdg2-1.xx&oh=66b156a494a01a0309b3f31fa324f704&oe=616EC71B', 
    'https://scontent-cdg2-1.xx.fbcdn.net/v/t31.18172-8/25398404_138168486898521_2291663673322887402_o.jpg?_nc_cat=100&ccb=1-5&_nc_sid=cdbe9c&_nc_ohc=7EekRBfuYiwAX9fqPGK&_nc_ht=scontent-cdg2-1.xx&oh=522106367a13bbcdf597b845db054376&oe=616F472B',
    6
),
(
    'Super chalet', 
    'Lorem ipsum dolor, sit amet consectetur adipisicing elit. Perferendis quod praesentium officiis voluptas fugit nihil harum tempora laudantium commodi at.', 
    '92700',
    'Marseille',
    'France',
    'rue de la soif',
    '50',
    2000,
    30,
    'https://images.pexels.com/photos/714258/pexels-photo-714258.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260',
    'https://images.pexels.com/photos/9587765/pexels-photo-9587765.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260',
    'https://images.pexels.com/photos/3214973/pexels-photo-3214973.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260',
    'https://images.pexels.com/photos/36347/cow-pasture-animal-almabtrieb.jpg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260',
    'https://images.pexels.com/photos/2647053/pexels-photo-2647053.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260',
    'https://images.pexels.com/photos/248167/pexels-photo-248167.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260',
    1
);


INSERT INTO "user" ("id", "firstname", "lastname", "email", "password") OVERRIDING SYSTEM VALUE VALUES
(666, 'deletedUser', 'deleterUser', 'deletedUser', 'deletedUser');



COMMIT;

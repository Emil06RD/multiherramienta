# MultiHerramientas

Proyecto universitario Flutter para Android con ocho pantallas, Material 3 y APIs públicas.

```sh
flutter pub get
flutter analyze
flutter test
flutter run
```

Noticias verificadas con HTTP 200 y tres publicaciones:
https://wordpress.org/news/wp-json/wp/v2/posts?per_page=3&orderby=date&order=desc

Los datos de contacto están en `lib/screens/about_screen.dart`. La foto del perfil es `assets/images/perfil.png`; el ícono de Android utiliza un recorte centrado de esa foto en `assets/images/perfil_icono.png`.

Para regenerar los íconos y compilar el APK:

```sh
dart run flutter_launcher_icons
flutter build apk --release
```

Las consultas necesitan Internet. Las APIs pueden aplicar límites o estar temporalmente fuera de servicio. Las noticias conservan su idioma original y los perfiles de Random User son perfiles de prueba del servicio.

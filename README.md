SERRAINNOVA (Flutter) - UI basada en tus mockups
================================================

Estructura:
- lib/models
- lib/routes
- lib/widgets
- lib/provider
- lib/pages

Pantallas:
1) Landing (logo + buscador + Comprar/Alquilar)
2) Listado (barra superior + filtros izquierda + tarjetas viviendas)
3) Detalle vivienda

Persistencia:
- SQLite (sqflite) para "búsquedas guardadas" (filtros seleccionados).

Ejecutar:
flutter pub get
flutter run

Notas:
- El logo en el mockup es un placeholder. Si tienes logo, añádelo como asset y cámbialo en widgets/logo_badge.dart.
- Layout responsive: en pantallas estrechas, los filtros pasan a Drawer (icono de filtro).


Web:
- En Chrome usamos SharedPreferences para persistencia (búsquedas guardadas).
- En móvil/desktop usamos SQLite (sqflite).

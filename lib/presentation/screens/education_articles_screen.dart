import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class EducationArticlesScreen extends StatelessWidget {
  final String categoryTitle;
  final IconData categoryIcon;

  const EducationArticlesScreen({
    super.key,
    required this.categoryTitle,
    required this.categoryIcon,
  });

  @override
  Widget build(BuildContext context) {
    final articles = _getArticlesForCategory(categoryTitle);

    return Scaffold(
      appBar: AppBar(title: Text(categoryTitle)),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: articles.length,
        itemBuilder: (context, index) {
          final article = articles[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: InkWell(
              onTap: () => _showArticle(context, article),
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: AppTheme.primaryColor.withValues(
                        alpha: 0.1,
                      ),
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            article.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            article.summary,
                            style: Theme.of(context).textTheme.bodyMedium,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(
                                Icons.access_time,
                                size: 14,
                                color: Colors.grey.shade500,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${article.readTimeMin} min lectura',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right,
                      color: AppTheme.textSecondary,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showArticle(BuildContext context, _Article article) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(title: Text(categoryTitle)),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  article.title,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 16,
                      color: Colors.grey.shade500,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${article.readTimeMin} min lectura',
                      style: TextStyle(color: Colors.grey.shade500),
                    ),
                  ],
                ),
                const Divider(height: 32),
                Text(
                  article.body,
                  style: const TextStyle(fontSize: 16, height: 1.7),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<_Article> _getArticlesForCategory(String category) {
    switch (category) {
      case 'Impacto del Sodio':
        return const [
          _Article(
            title: '¿Qué es el sodio y por qué importa?',
            summary:
                'El sodio es un mineral esencial, pero en exceso eleva la presión arterial.',
            body:
                'El sodio es un mineral esencial para el funcionamiento del cuerpo. '
                'Ayuda a mantener el equilibrio de líquidos y es necesario para la '
                'transmisión nerviosa y la contracción muscular.\n\n'
                'Sin embargo, cuando consumimos demasiado sodio, el cuerpo retiene '
                'más agua para diluirlo. Esto aumenta el volumen de sangre, lo que '
                'hace que el corazón trabaje más y eleva la presión arterial.\n\n'
                'La OMS recomienda no superar los 2,000 mg de sodio al día para '
                'adultos. Para personas con hipertensión, el límite recomendado es '
                'de 1,500 mg/día según la dieta DASH.\n\n'
                '💡 Tip: Una cucharadita de sal contiene aproximadamente 2,300 mg '
                'de sodio, más del límite diario recomendado para personas con HTA.',
            readTimeMin: 3,
          ),
          _Article(
            title: 'Fuentes ocultas de sodio',
            summary:
                'Muchos alimentos procesados contienen más sodio del que imaginas.',
            body:
                'El 75% del sodio que consumimos no viene del salero, sino de '
                'alimentos procesados y preparados. Estas son las fuentes más comunes:\n\n'
                '🍞 Pan y productos de panadería\n'
                '🧀 Quesos procesados\n'
                '🥫 Sopas y caldos enlatados\n'
                '🌭 Embutidos y carnes procesadas\n'
                '🍕 Comida rápida\n'
                '🥫 Salsas y condimentos\n\n'
                'Una sola porción de sopa enlatada puede contener hasta 900 mg de '
                'sodio, es decir, más de la mitad del límite diario recomendado.\n\n'
                '💡 Tip: Lee siempre la etiqueta nutricional y busca opciones "sin '
                'sal agregada" o "bajo en sodio".',
            readTimeMin: 4,
          ),
          _Article(
            title: 'Cómo reducir el sodio gradualmente',
            summary:
                'Estrategias prácticas para bajar tu consumo de sodio sin perder sabor.',
            body:
                'Reducir el sodio no tiene que ser abrupto. Aquí tienes estrategias '
                'que puedes implementar gradualmente:\n\n'
                '1️⃣ Cocina en casa: Tendrás control total sobre la sal.\n\n'
                '2️⃣ Usa especias y hierbas: Ajo, limón, orégano, cilantro y '
                'pimienta son excelentes alternativas.\n\n'
                '3️⃣ Reduce gradualmente: Baja la sal un poco cada semana. Tu '
                'paladar se adaptará.\n\n'
                '4️⃣ Enjuaga los alimentos enlatados: Reduce hasta un 40% del sodio.\n\n'
                '5️⃣ Elige opciones "sin sal" o "bajo en sodio" en el supermercado.\n\n'
                '6️⃣ Evita agregar sal en la mesa.\n\n'
                '💡 Después de 2-3 semanas reduciendo el sodio, tu paladar se '
                'acostumbra y los alimentos muy salados te parecerán excesivos.',
            readTimeMin: 3,
          ),
        ];
      case 'Lectura de Etiquetas':
        return const [
          _Article(
            title: 'Cómo leer una etiqueta nutricional',
            summary:
                'Guía paso a paso para interpretar la información de los envases.',
            body:
                'Saber leer una etiqueta nutricional es clave para controlar tu '
                'ingesta de sodio. Aquí te explicamos cómo:\n\n'
                '📋 Tamaño de la porción: Todo lo demás se basa en esta cantidad. '
                'Asegúrate de saber cuántas porciones consumes.\n\n'
                '🧂 Sodio: Busca este valor. Menos de 140 mg por porción se '
                'considera "bajo en sodio".\n\n'
                '📊 % Valor Diario: Se basa en 2,300 mg/día. Si tienes HTA, tu '
                'límite es 1,500 mg, así que los porcentajes reales son más altos.\n\n'
                '⚠️ Cuidado con: "Sabor natural", "glutamato monosódico", '
                '"bicarbonato de sodio" - todos contienen sodio.\n\n'
                '💡 Regla rápida: 5% o menos de sodio por porción = bajo. '
                '20% o más = alto.',
            readTimeMin: 4,
          ),
          _Article(
            title: 'Términos engañosos en los envases',
            summary: 'No te dejes engañar por el marketing alimentario.',
            body:
                'Los fabricantes usan términos que pueden confundir:\n\n'
                '❌ "Reducido en sodio": Tiene 25% menos que la versión original, '
                'pero puede seguir siendo alto.\n\n'
                '❌ "Light en sodio": 50% menos que el original.\n\n'
                '✅ "Bajo en sodio": Menos de 140 mg por porción.\n\n'
                '✅ "Muy bajo en sodio": Menos de 35 mg por porción.\n\n'
                '✅ "Sin sodio": Menos de 5 mg por porción.\n\n'
                '⚠️ "Sin sal agregada" no significa sin sodio. El alimento puede '
                'contener sodio naturalmente.\n\n'
                '💡 Siempre revisa los mg de sodio en la tabla nutricional, no '
                'confíes solo en las frases del frente del envase.',
            readTimeMin: 3,
          ),
        ];
      case 'Mitos Alimentarios':
        return const [
          _Article(
            title: 'Mito: La sal marina es más saludable',
            summary:
                'La sal marina y la sal de mesa tienen la misma cantidad de sodio.',
            body:
                '🔍 Mito: "La sal marina es más saludable que la sal común"\n\n'
                '❌ FALSO\n\n'
                'Tanto la sal marina como la sal de mesa contienen aproximadamente '
                '40% de sodio (alrededor de 2,300 mg por cucharadita).\n\n'
                'La sal marina puede contener trazas de otros minerales, pero en '
                'cantidades tan pequeñas que no aportan beneficios significativos.\n\n'
                'Lo mismo aplica para la sal del Himalaya, la sal kosher y otras '
                'variedades: todas elevan la presión arterial por igual.\n\n'
                '💡 Lo que importa es la cantidad total de sodio que consumes, '
                'sin importar el tipo de sal.',
            readTimeMin: 2,
          ),
          _Article(
            title: 'Mito: Si no le pongo sal, no tiene sodio',
            summary: 'Muchos alimentos naturales contienen sodio.',
            body:
                '🔍 Mito: "Si no agrego sal a mi comida, no estoy consumiendo sodio"\n\n'
                '❌ FALSO\n\n'
                'El 75% del sodio que consumimos viene de alimentos procesados, '
                'no del salero. Además, muchos alimentos naturales contienen '
                'sodio:\n\n'
                '• Leche: ~120 mg por taza\n'
                '• Apio: ~35 mg por tallo\n'
                '• Remolacha: ~65 mg por taza\n\n'
                'Los mayores "culpables ocultos" son:\n'
                '• Pan (150-200 mg por rebanada)\n'
                '• Queso (200-400 mg por porción)\n'
                '• Condimentos y salsas\n\n'
                '💡 Lleva un registro de tus alimentos para conocer tu consumo real.',
            readTimeMin: 3,
          ),
          _Article(
            title: 'Mito: Solo los mayores tienen hipertensión',
            summary: 'La HTA puede afectar a personas de cualquier edad.',
            body:
                '🔍 Mito: "Solo los adultos mayores tienen presión alta"\n\n'
                '❌ FALSO\n\n'
                'Si bien el riesgo aumenta con la edad, la hipertensión puede '
                'afectar a personas de cualquier edad, incluyendo jóvenes adultos.\n\n'
                'Factores de riesgo en jóvenes:\n'
                '• Dieta alta en sodio y baja en potasio\n'
                '• Sedentarismo\n'
                '• Sobrepeso y obesidad\n'
                '• Estrés crónico\n'
                '• Antecedentes familiares\n'
                '• Consumo excesivo de alcohol\n\n'
                '💡 La detección temprana es clave. Mide tu presión regularmente '
                'sin importar tu edad.',
            readTimeMin: 3,
          ),
          _Article(
            title: 'Mito: El café es peligroso para la hipertensión',
            summary:
                'El café en moderación no eleva la presión de forma permanente.',
            body:
                '🔍 Mito: "Debo eliminar el café por completo si tengo HTA"\n\n'
                '⚠️ PARCIALMENTE FALSO\n\n'
                'La cafeína puede elevar la presión arterial temporalmente (1-3 '
                'horas después del consumo). Sin embargo, estudios muestran que '
                'el consumo moderado (2-3 tazas al día) no aumenta el riesgo '
                'cardiovascular a largo plazo.\n\n'
                'Recomendaciones:\n'
                '✅ Limita el consumo a 2-3 tazas al día\n'
                '✅ Evita el café antes de medir tu presión\n'
                '✅ Prefiere café filtrado sobre espresso\n'
                '❌ Evita bebidas energéticas con alta cafeína\n\n'
                '💡 Si notas que el café eleva tu PA significativamente, '
                'consulta con tu médico sobre la cantidad adecuada para ti.',
            readTimeMin: 3,
          ),
        ];
      case 'Dieta DASH':
        return const [
          _Article(
            title: '¿Qué es la dieta DASH?',
            summary:
                'Una guía alimentaria científicamente probada para reducir la presión.',
            body:
                'DASH significa "Dietary Approaches to Stop Hypertension" '
                '(Enfoques Dietéticos para Detener la Hipertensión).\n\n'
                'Es un plan alimenticio desarrollado por el NIH de Estados Unidos '
                'que ha demostrado reducir la presión arterial en solo 2 semanas.\n\n'
                '📋 Principios básicos:\n'
                '• Rica en frutas, verduras y granos integrales\n'
                '• Incluye lácteos bajos en grasa\n'
                '• Incluye proteínas magras (pollo, pescado, legumbres)\n'
                '• Limita grasas saturadas y colesterol\n'
                '• Limita dulces y bebidas azucaradas\n'
                '• Máximo 1,500 mg de sodio al día\n\n'
                '📊 Resultados comprobados:\n'
                '• Reduce la sistólica en 8-14 mmHg\n'
                '• Efectos visibles en 2 semanas\n'
                '• Beneficios sostenidos a largo plazo',
            readTimeMin: 4,
          ),
          _Article(
            title: 'Porciones recomendadas DASH',
            summary: 'Cantidades diarias recomendadas por grupo de alimentos.',
            body:
                'Para una dieta de aproximadamente 2,000 calorías:\n\n'
                '🌾 Granos integrales: 6-8 porciones/día\n'
                '   (1 rebanada de pan, ½ taza de arroz)\n\n'
                '🥬 Verduras: 4-5 porciones/día\n'
                '   (1 taza cruda, ½ taza cocida)\n\n'
                '🍎 Frutas: 4-5 porciones/día\n'
                '   (1 fruta mediana, ½ taza de jugo natural)\n\n'
                '🥛 Lácteos bajos en grasa: 2-3 porciones/día\n'
                '   (1 taza de leche, 1 yogurt)\n\n'
                '🍗 Carnes magras: 2 o menos porciones/día\n'
                '   (85g de carne cocida)\n\n'
                '🥜 Frutos secos y legumbres: 4-5 porciones/semana\n'
                '   (⅓ taza de nueces, ½ taza de legumbres)\n\n'
                '🫒 Grasas: 2-3 porciones/día\n'
                '   (1 cucharadita de aceite de oliva)',
            readTimeMin: 3,
          ),
          _Article(
            title: 'Alimentos ricos en potasio',
            summary: 'El potasio ayuda a contrarrestar los efectos del sodio.',
            body:
                'El potasio ayuda a relajar los vasos sanguíneos y a que los '
                'riñones eliminen el sodio excedente. La meta es consumir al '
                'menos 4,700 mg al día.\n\n'
                '🏆 Top alimentos ricos en potasio:\n\n'
                '🍌 Plátano: 422 mg (1 mediano)\n'
                '🥔 Papa horneada: 926 mg (1 mediana)\n'
                '🍠 Camote: 541 mg (1 mediano)\n'
                '🥬 Espinaca cocida: 839 mg (1 taza)\n'
                '🫘 Frijoles blancos: 1,189 mg (1 taza)\n'
                '🥑 Aguacate: 975 mg (1 entero)\n'
                '🐟 Salmón: 534 mg (85g)\n'
                '🍊 Naranja: 326 mg (1 grande)\n'
                '🥛 Yogurt: 573 mg (1 taza)\n'
                '🍅 Tomate: 292 mg (1 mediano)\n\n'
                '💡 Combina estos alimentos a lo largo del día para alcanzar '
                'la meta de potasio.',
            readTimeMin: 3,
          ),
        ];
      default:
        return const [];
    }
  }
}

class _Article {
  final String title;
  final String summary;
  final String body;
  final int readTimeMin;

  const _Article({
    required this.title,
    required this.summary,
    required this.body,
    required this.readTimeMin,
  });
}

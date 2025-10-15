# QCM App Workshop - "Quel Sorcier de l'EPSI es-tu ?"

Une application Flutter interactive qui permet de découvrir votre profil de sorcier tech à l'EPSI ! Cette app propose un questionnaire à choix multiples (QCM) amusant pour déterminer quel type de sorcier numérique vous êtes parmi les quatre archétypes.

## 🧙‍♂️ Les Archétypes de Sorciers

- **Cryptomancien** - Maître de la sécurité et du chiffrement
- **Architectomage** - Expert en conception de systèmes complexes  
- **Datalchimiste** - Alchimiste des données et de l'analyse
- **Technomancien** - Magicien de la technologie et de l'innovation

## ✨ Fonctionnalités

- 📱 Interface utilisateur moderne et intuitive
- 🎯 Questionnaire interactif avec système de scoring
- 🎨 Animations Lottie pour une expérience visuelle enrichie
- 💾 Sauvegarde locale des résultats avec Hive
- 🎭 Personnalisation avec Google Fonts
- 📤 Partage des résultats avec vos amis
- 🌙 Support thème clair/sombre

## 🛠️ Technologies Utilisées

- **Flutter** - Framework de développement cross-platform
- **Riverpod** - Gestion d'état réactive
- **Hive** - Base de données locale NoSQL
- **Lottie** - Animations vectorielles
- **Google Fonts** - Typographies personnalisées
- **Share Plus** - Fonctionnalité de partage

## 📋 Prérequis

Avant de commencer, assurez-vous d'avoir installé :

- [Flutter SDK](https://flutter.dev/docs/get-started/install) (version 2.19.0 ou supérieure)
- [Dart SDK](https://dart.dev/get-dart) (inclus avec Flutter)
- Un IDE (VS Code, Android Studio, ou IntelliJ)
- [Git](https://git-scm.com/)

### Vérification de l'installation Flutter

```bash
flutter doctor
```

## 🚀 Installation et Configuration

### 1. Cloner le projet

```bash
git clone https://github.com/eliseomurillo9/qcm-app-workshop.git
cd qcm-app-workshop
```

### 2. Installer les dépendances

```bash
flutter pub get
```

### 3. Générer les fichiers Hive (si nécessaire)

```bash
flutter packages pub run build_runner build
```

### 4. Lancer l'application

```bash
flutter run
```

## 📁 Structure du Projet

```
lib/
├── main.dart                 # Point d'entrée de l'application
├── models/                   # Modèles de données
│   ├── option.dart
│   ├── question.dart
│   ├── quiz.dart
│   └── sorciere.dart
├── providers/                # Providers Riverpod
│   └── quiz_provider.dart
├── services/                 # Services métier
│   ├── local_quiz_service.dart
│   ├── result_service.dart
│   └── storage_service.dart
├── ui/                       # Interface utilisateur
│   └── screens/             # Écrans de l'application
└── utils/                    # Utilitaires
    └── themes.dart          # Configuration des thèmes

assets/
├── quiz.json                # Données du questionnaire
└── lottie/                  # Animations Lottie
    └── patronus.json
```

## 🎮 Utilisation

1. **Accueil** : Lancez l'application et appuyez sur "Commencer le Quiz"
2. **Questionnaire** : Répondez aux questions en sélectionnant vos réponses préférées
3. **Résultats** : Découvrez votre archétype de sorcier EPSI
4. **Partage** : Partagez vos résultats avec vos amis !

## 🔧 Configuration du Quiz

Le questionnaire est configuré via le fichier `assets/quiz.json`. Vous pouvez :

- Modifier les questions existantes
- Ajouter de nouvelles questions
- Ajuster les scores pour chaque archétype
- Personnaliser les archétypes de sorciers

Format des questions :
```json
{
  "id": 1,
  "text": "Votre question ici ?",
  "options": [
    {
      "id": "A",
      "text": "Option A",
      "scores": {
        "Cryptomancien": 3,
        "Architectomage": 1,
        "Datalchimiste": 1,
        "Technomancien": 2
      }
    }
  ]
}
```

## 📱 Plateformes Supportées

- ✅ Android
- ✅ iOS
- ✅ Web
- ✅ Windows
- ✅ macOS
- ✅ Linux

## 🧪 Tests

Lancer les tests unitaires :

```bash
flutter test
```

## 📦 Build de Production

### Android (APK)
```bash
flutter build apk --release
```

### iOS
```bash
flutter build ios --release
```

### Web
```bash
flutter build web --release
```

## 🤝 Contribution

Les contributions sont les bienvenues ! Pour contribuer :

1. Forkez le projet
2. Créez votre branche feature (`git checkout -b feature/AmazingFeature`)
3. Committez vos changements (`git commit -m 'Add some AmazingFeature'`)
4. Poussez vers la branche (`git push origin feature/AmazingFeature`)
5. Ouvrez une Pull Request

## 📝 Licence

Ce projet est sous licence MIT. Voir le fichier `LICENSE` pour plus de détails.

## 👨‍💻 Auteur

**Eliseo Murillo** - [GitHub](https://github.com/eliseomurillo9)

## 🙏 Remerciements

- EPSI pour l'inspiration du thème
- L'équipe Flutter pour l'excellent framework
- La communauté open source pour les packages utilisés

## 📞 Support

Si vous rencontrez des problèmes ou avez des questions :

1. Consultez la [documentation Flutter](https://flutter.dev/docs)
2. Ouvrez une [issue](https://github.com/eliseomurillo9/qcm-app-workshop/issues)
3. Contactez-moi sur [GitHub](https://github.com/eliseomurillo9)

---

*Découvrez votre sorcier intérieur et que la magie du code soit avec vous ! 🪄✨*

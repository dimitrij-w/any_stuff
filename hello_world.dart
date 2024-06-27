import 'dart:math';

class User {
    String id;
    bool hilfeSuche;
    bool hilfeGeben;
    DateTime datum;
    String ort;
    DateTime letzteLogin;
    double bewertung;

    User(this.id, this.hilfeSuche, this.hilfeGeben, this.datum, this.ort, this.letzteLogin, this.bewertung);
}

class CollaborativeFiltering {
    final List<User> users;

    CollaborativeFiltering(this.users);

    double similarity(User user1, User user2) {
        // Für diese Beispielberechnung nutzen wir nur das Attribut 'Bewertung'
        var rating1 = user1.bewertung;
        var rating2 = user2.bewertung;

        // Berechnung der Ähnlichkeit basierend auf der Differenz der Bewertungen
        var difference = (rating1 - rating2).abs();
        return 1 / (1 + difference); // Kleinere Differenzen führen zu höheren Ähnlichkeitswerten
    }

    List<User> recommend(User user) {
        var scores = <User, double>{};

        for (var otherUser in users) {
            if (otherUser.id == user.id) continue;

            var sim = similarity(user, otherUser);

            if (sim <= 0) continue;

            scores[otherUser] = sim;
        }

        var sortedScores = scores.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));

        return sortedScores.map((entry) => entry.key).toList();
    }
}

void main() {
    var users = [
        User('1', true, false, DateTime.parse('2024-06-01'), 'Berlin', DateTime.parse('2024-06-20'), 4.5),
        User('2', false, true, DateTime.parse('2024-06-05'), 'Hamburg', DateTime.parse('2024-06-22'), 3.0),
        User('3', true, true, DateTime.parse('2024-06-10'), 'Berlin', DateTime.parse('2024-06-21'), 5.0),
        User('4', false, false, DateTime.parse('2024-06-15'), 'Munich', DateTime.parse('2024-06-23'), 2.5),
        User('5', true, false, DateTime.parse('2024-06-18'), 'Berlin', DateTime.parse('2024-06-24'), 4.0),
    ];

    var cf = CollaborativeFiltering(users);
    var user = users[0]; // Benutzer, für den Empfehlungen erstellt werden sollen
    print('Empfehlungen für Benutzer ${user.id}:');
    var recommendations = cf.recommend(user);

    recommendations.forEach((recommendedUser) {
        print('Benutzer ${recommendedUser.id} mit Bewertung ${recommendedUser.bewertung}');
    });
}

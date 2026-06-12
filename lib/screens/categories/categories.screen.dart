import 'package:flutter/material.dart';

class GamificationScreen extends StatelessWidget {
  const GamificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FB),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [

              /// HERO CARD
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xff6A11CB),
                      Color(0xff2575FC),
                    ],
                  ),
                ),
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 35,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.person,
                        size: 40,
                        color: Color(0xff2575FC),
                      ),
                    ),

                    const SizedBox(height: 16),

                    const Text(
                      "Liga Ouro",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      "Nível 12",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 18,
                      ),
                    ),

                    const SizedBox(height: 20),

                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "1250 XP",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "1500 XP",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: LinearProgressIndicator(
                        value: 0.83,
                        minHeight: 14,
                        backgroundColor: Colors.white24,
                      ),
                    ),

                    const SizedBox(height: 10),

                    const Text(
                      "250 XP para o próximo nível",
                      style: TextStyle(
                        color: Colors.white70,
                      ),
                    )
                  ],
                ),
              ),

              const SizedBox(height: 25),

              /// ESTATÍSTICAS
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      icon: Icons.star,
                      value: "1250",
                      title: "XP",
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _StatCard(
                      icon: Icons.school,
                      value: "12",
                      title: "Aulas",
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _StatCard(
                      icon: Icons.local_fire_department,
                      value: "7",
                      title: "Dias",
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              /// AULAS
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "📚 Trilha de Aprendizagem",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              _LessonCard(
                title: "Introdução à Educação Financeira",
                xp: 50,
                completed: true,
              ),

              _LessonCard(
                title: "Como criar um orçamento",
                xp: 100,
                completed: true,
              ),

              _LessonCard(
                title: "Reserva de Emergência",
                xp: 150,
                completed: false,
              ),

              _LessonCard(
                title: "Primeiros Investimentos",
                xp: 200,
                completed: false,
              ),

              const SizedBox(height: 30),

              /// CONQUISTAS
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "🏅 Conquistas",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 15),

              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: const [
                  _AchievementCard("Primeira Aula"),
                  _AchievementCard("500 XP"),
                  _AchievementCard("Top 3"),
                  _AchievementCard("7 Dias"),
                ],
              ),

              const SizedBox(height: 30),

              /// RANKING
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "🏆 Ranking",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 15),

              _RankingTile(
                rank: "🥇",
                name: "Ana",
                xp: 3200,
              ),

              _RankingTile(
                rank: "🥈",
                name: "João",
                xp: 2800,
              ),

              _RankingTile(
                rank: "🥉",
                name: "Você",
                xp: 2500,
                highlight: true,
              ),

              const SizedBox(height: 30),

              /// MISSÃO DIÁRIA
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.orange.shade100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    const Text(
                      "🎯 Missão Diária",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    const Text(
                      "Assista 2 aulas hoje",
                      style: TextStyle(fontSize: 18),
                    ),

                    const SizedBox(height: 10),

                    const Text(
                      "+100 XP",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 15),

                    ElevatedButton(
                      onPressed: () {},
                      child: const Text("Concluir"),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String title;

  const _StatCard({
    required this.icon,
    required this.value,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(title),
          ],
        ),
      ),
    );
  }
}

class _LessonCard extends StatelessWidget {
  final String title;
  final int xp;
  final bool completed;

  const _LessonCard({
    required this.title,
    required this.xp,
    required this.completed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(
          completed
              ? Icons.check_circle
              : Icons.play_circle_fill,
          color: completed
              ? Colors.green
              : Colors.blue,
        ),
        title: Text(title),
        subtitle: Text("+$xp XP"),
        trailing: ElevatedButton(
          onPressed: completed ? null : () {},
          child: Text(
            completed
                ? "Concluída"
                : "Assistir",
          ),
        ),
      ),
    );
  }
}

class _AchievementCard extends StatelessWidget {
  final String title;

  const _AchievementCard(this.title);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.green.shade100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(title),
    );
  }
}

class _RankingTile extends StatelessWidget {
  final String rank;
  final String name;
  final int xp;
  final bool highlight;

  const _RankingTile({
    required this.rank,
    required this.name,
    required this.xp,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: highlight
          ? Colors.amber.shade100
          : null,
      child: ListTile(
        leading: Text(
          rank,
          style: const TextStyle(fontSize: 28),
        ),
        title: Text(name),
        trailing: Text(
          "$xp XP",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

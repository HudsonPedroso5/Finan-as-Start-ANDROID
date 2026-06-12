
import 'package:fintracker/bloc/cubit/app_cubit.dart';
import 'package:fintracker/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AppCubit>();
    final state = context.watch<AppCubit>().state;

    final colorChoices = [
      Colors.green,
      Colors.blue,
      Colors.purple,
      Colors.orange,
      Colors.teal,
      Colors.red,
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Perfil')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Header Premium
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xff6A11CB),
                  Color(0xff2575FC),
                ],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              children: [
                Stack(
                  children: [
                    const CircleAvatar(radius: 50, backgroundImage: AssetImage('assets/avatar.png')),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.white,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          icon: const Icon(Icons.edit, size: 16),
                          onPressed: () => showDialog(context: context, builder: (_) => const EditProfileDialog()),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(state.username ?? 'João Silva', style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                const Text('Mestre Financeiro', style: TextStyle(color: Colors.white70)),
                const SizedBox(height: 20),
                ClipRRect(borderRadius: BorderRadius.circular(20), child: LinearProgressIndicator(value: .75, minHeight: 12)),
                const SizedBox(height: 8),
                const Text('1250 / 1500 XP', style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Estatísticas
          Row(
            children: const [
              Expanded(
                child: _ProfileStatCard(title: 'XP', value: '1250', icon: Icons.star),
              ),
              SizedBox(width: 8),
              Expanded(
                child: _ProfileStatCard(title: 'Metas', value: '5', icon: Icons.flag),
              ),
              SizedBox(width: 8),
              Expanded(
                child: _ProfileStatCard(title: 'Aulas', value: '12', icon: Icons.school),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Badges
          const Text('🏅 Badges', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: 3,
            physics: const NeverScrollableScrollPhysics(),
            children: const [
              _BadgeCard(icon: Icons.star, title: '500 XP'),
              _BadgeCard(icon: Icons.school, title: 'Primeira Aula'),
              _BadgeCard(icon: Icons.flag, title: 'Primeira Meta'),
              _BadgeCard(icon: Icons.emoji_events, title: 'Top 3'),
              _BadgeCard(icon: Icons.local_fire_department, title: '7 Dias'),
              _BadgeCard(icon: Icons.workspace_premium, title: 'Mestre'),
            ],
          ),
          const SizedBox(height: 16),

          // Conquistas
          const Text('Conquistas', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const Icon(Icons.emoji_events, color: Colors.amber),
              title: const Text('Top 3 do Ranking'),
              subtitle: const Text('Conquistado em 12/06/2026'),
            ),
          ),
          const SizedBox(height: 16),

          // Edit profile button
          ElevatedButton.icon(
            onPressed: () => showDialog(context: context, builder: (_) => const EditProfileDialog()),
            icon: const Icon(Icons.edit),
            label: const Text('Editar Perfil'),
          ),
          const SizedBox(height: 16),

          // Progresso Financeiro
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(20)),
            child: Column(
              children: const [
                Text('💰 Progresso Financeiro'),
                SizedBox(height: 10),
                LinearProgressIndicator(value: .65),
                SizedBox(height: 10),
                Text('65% das metas concluídas'),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Configurações como cards
          Card(
            child: ListTile(
              leading: const Icon(Icons.palette),
              title: const Text('Tema'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (_) => Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Wrap(
                      spacing: 12,
                      children: colorChoices
                          .map((color) => ChoiceChip(
                                label: const Text(''),
                                selected: state.themeColor == color.value,
                                avatar: CircleAvatar(backgroundColor: color),
                                onSelected: (_) => cubit.updateThemeColor(color.value),
                              ))
                          .toList(),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text('Notificações'),
              trailing: Switch(
                value: true,
                onChanged: (_) {},
              ),
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const Icon(Icons.info),
              title: const Text('Sobre'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => showAboutDialog(context: context, applicationName: 'Finanças Start'),
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Sair'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Sair'),
                    content: const Text('Deseja realmente sair da conta?'),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
                      FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Sair')),
                    ],
                  ),
                );
                if (confirm == true) {
                  await AuthService.logout();
                  cubit.resetAll();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _BadgeCard extends StatelessWidget {
  final IconData icon;
  final String title;

  const _BadgeCard({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 36, color: Colors.amber),
          const SizedBox(height: 8),
          Text(title, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class _ProfileStatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _ProfileStatCard({required this.title, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon),
            const SizedBox(height: 10),
            Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            Text(title),
          ],
        ),
      ),
    );
  }
}

class EditProfileDialog extends StatefulWidget {
  const EditProfileDialog({super.key});

  @override
  State<EditProfileDialog> createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<EditProfileDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: context.read<AppCubit>().state.username ?? '');
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Editar Perfil'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(decoration: const InputDecoration(labelText: 'Nome'), controller: _nameController),
          const SizedBox(height: 8),
          TextField(decoration: const InputDecoration(labelText: 'Email'), controller: _emailController),
          const SizedBox(height: 8),
          TextField(decoration: const InputDecoration(labelText: 'Foto (URL)')),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
        FilledButton(
          onPressed: () {
            context.read<AppCubit>().updateUsername(_nameController.text.trim());
            Navigator.pop(context);
          },
          child: const Text('Salvar'),
        ),
      ],
    );
  }
}


import 'package:flutter/material.dart';
import '../../../shared/theme/tokens.dart';

enum LifeSpace {
  life(
    'life',
    'My Life',
    'Make room for what matters.',
    Icons.wb_sunny_outlined,
    Aurora.teal,
    'A connected place for your daily plans, tasks and commitments.',
  ),
  goals(
    'goals',
    'My Goals',
    'Give your ambitions a direction.',
    Icons.auto_awesome_outlined,
    Aurora.amber,
    'Turn meaningful ambitions into milestones and manageable steps.',
  ),
  money(
    'money',
    'My Money',
    'A clearer view of your money.',
    Icons.account_balance_wallet_outlined,
    Aurora.teal,
    'Understand expenses, budgets and savings in one personal space.',
  ),
  learning(
    'learning',
    'My Learning',
    'Keep your curiosity moving.',
    Icons.school_outlined,
    Aurora.orchid,
    'Connect your skills, learning paths and study routines.',
  ),
  career(
    'career',
    'My Career',
    'Build your next chapter.',
    Icons.work_outline_rounded,
    Aurora.amber,
    'Bring your professional growth, preparation and opportunities together.',
  ),
  wellness(
    'wellness',
    'My Wellness',
    'Progress at your own pace.',
    Icons.spa_outlined,
    Aurora.rose,
    'A supportive space for habits, routines and personal reflection.',
  ),
  knowledge(
    'knowledge',
    'My Knowledge',
    'Let your ideas connect.',
    Icons.hub_outlined,
    Aurora.orchid,
    'Organize notes and explore connections across your personal knowledge.',
  ),
  travel(
    'travel',
    'My Travel',
    'Make space for discovery.',
    Icons.explore_outlined,
    Aurora.rose,
    'Bring future destinations, travel plans and itineraries into focus.',
  );

  const LifeSpace(
    this.id,
    this.label,
    this.headline,
    this.icon,
    this.accent,
    this.description,
  );
  final String id;
  final String label;
  final String headline;
  final IconData icon;
  final Color accent;
  final String description;
  String get shortLabel => label.substring(3);
  String get route => switch (this) {
    LifeSpace.life => '/planner',
    LifeSpace.goals => '/goals',
    LifeSpace.wellness => '/modules/wellness',
    LifeSpace.knowledge => '/knowledge-universe',
    LifeSpace.money => '/modules/finance',
    LifeSpace.learning => '/modules/learning',
    LifeSpace.career => '/modules/career',
    LifeSpace.travel => '/modules/travel',
  };
}

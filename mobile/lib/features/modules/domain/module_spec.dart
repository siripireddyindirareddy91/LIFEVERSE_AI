import 'package:flutter/material.dart';

class ModuleSpec {
  const ModuleSpec(
    this.id,
    this.title,
    this.headline,
    this.description,
    this.icon,
    this.kinds,
  );
  final String id, title, headline, description;
  final IconData icon;
  final Map<String, String> kinds;
}

const advancedModules = {
  'finance': ModuleSpec(
    'finance',
    'Money Intelligence',
    'Make room for what matters.',
    'Track your own income, spending and commitments. Currencies stay separate; reports use manual entries.',
    Icons.account_balance_wallet_outlined,
    {
      'entry': 'Transactions',
      'budget': 'Budgets',
      'saving': 'Savings',
      'bill': 'Bills & subscriptions',
    },
  ),
  'learning': ModuleSpec(
    'learning',
    'Learning Intelligence',
    'Keep your curiosity moving.',
    'Build learning paths, capture notes and practice with your own flashcards and quiz questions.',
    Icons.school_outlined,
    {
      'course': 'Courses',
      'study_note': 'Study notes',
      'flashcard': 'Flashcards',
      'quiz': 'Quizzes',
    },
  ),
  'career': ModuleSpec(
    'career',
    'Career Intelligence',
    'Build your next chapter.',
    'Track real applications, prepare a factual resume and reflect on your next steps.',
    Icons.work_outline,
    {'application': 'Applications', 'resume': 'Resumes'},
  ),
  'wellness': ModuleSpec(
    'wellness',
    'My Wellness',
    'Progress at your own pace.',
    'A supportive space for self-reported logs, journaling and routines. Your records are personal, not a diagnosis.',
    Icons.spa_outlined,
    {'wellness_log': 'Daily logs', 'routine': 'Routines'},
  ),
  'travel': ModuleSpec(
    'travel',
    'Travel Intelligence',
    'Leave room for discovery.',
    'Bring trips, itinerary notes, planned costs and packing lists together. Nothing here makes a booking.',
    Icons.explore_outlined,
    {'trip': 'Trips', 'itinerary': 'Itinerary', 'packing': 'Packing'},
  ),
  'future': ModuleSpec(
    'future',
    'Future Studio',
    'Explore a possible next chapter.',
    'Compare scenarios using your own assumptions. Projections are estimates, never promises.',
    Icons.auto_graph,
    {'scenario': 'Scenarios'},
  ),
};
const kindNames = {
  'entry': 'transaction',
  'budget': 'budget',
  'saving': 'savings goal',
  'bill': 'bill or subscription',
  'course': 'course',
  'study_note': 'study note',
  'flashcard': 'flashcard',
  'quiz': 'quiz question',
  'application': 'application',
  'resume': 'resume',
  'wellness_log': 'daily log',
  'routine': 'routine',
  'trip': 'trip',
  'itinerary': 'itinerary item',
  'packing': 'packing item',
  'scenario': 'scenario',
};
const parentKinds = {
  'study_note': 'course',
  'flashcard': 'course',
  'quiz': 'course',
  'itinerary': 'trip',
  'packing': 'trip',
};

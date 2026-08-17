#!/bin/bash

if [ -z "$1" ]; then
  echo "❌ Error: Please provide a feature name."
  echo "Usage: ./scripts/feature.sh <feature_name>"
  exit 1
fi

FEATURE_NAME=$1
BASE_PATH="lib/features/$FEATURE_NAME"

echo "📂 Creating clean-architecture structure for feature: $FEATURE_NAME"

mkdir -p "$BASE_PATH/data/datasources"
mkdir -p "$BASE_PATH/data/models"
mkdir -p "$BASE_PATH/data/repositories"
mkdir -p "$BASE_PATH/domain/entities"
mkdir -p "$BASE_PATH/domain/repositories"
mkdir -p "$BASE_PATH/domain/usecases"
mkdir -p "$BASE_PATH/presentation/cubit"
mkdir -p "$BASE_PATH/presentation/pages"
mkdir -p "$BASE_PATH/presentation/widgets"

# Create a placeholder entity to ensure the directory is recognized
cat <<EOF > "$BASE_PATH/domain/entities/${FEATURE_NAME}_entity.dart"
import 'package:equatable/equatable.dart';

class ${FEATURE_NAME^}Entity extends Equatable {
  const ${FEATURE_NAME^}Entity();

  @override
  List<Object?> get props => [];
}
EOF

echo "✅ Feature structure created at $BASE_PATH"

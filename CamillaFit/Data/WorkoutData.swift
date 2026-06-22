import Foundation

struct WorkoutData {

    // MARK: - Strength Training (40s work / 15s rest)

    static let strengthExercises: [Exercise] = [
        Exercise(
            name: "Goblet Squat",
            description: "Hold kettlebell at chest. Squat deep, elbows between knees. Drive through heels.",
            equipment: .kettlebell,
            gifName: "goblet_squat",
            targetMuscles: "Legs / Glutes",
            sfSymbolFallback: "figure.strengthtraining.functional"
        ),
        Exercise(
            name: "Romanian Deadlift",
            description: "Dumbbells in front of thighs. Hinge at hips, slight knee bend. Feel the hamstring stretch.",
            equipment: .dumbbells,
            gifName: "romanian_deadlift",
            targetMuscles: "Hamstrings / Back",
            sfSymbolFallback: "figure.strengthtraining.traditional"
        ),
        Exercise(
            name: "Kettlebell Swing",
            description: "Hinge and snap hips forward. Arms are just along for the ride. Power from the glutes.",
            equipment: .kettlebell,
            gifName: "kettlebell_swing",
            targetMuscles: "Full Body / Cardio",
            sfSymbolFallback: "figure.highintensity.intervaltraining"
        ),
        Exercise(
            name: "Floor Press",
            description: "Lie on floor, dumbbells above chest. Lower until elbows touch floor, press up.",
            equipment: .dumbbells,
            gifName: "floor_press",
            targetMuscles: "Chest / Triceps",
            sfSymbolFallback: "figure.strengthtraining.traditional"
        ),
        Exercise(
            name: "Bent-Over Row",
            description: "Hinge forward 45°, barbell hanging. Pull to lower chest, squeeze shoulder blades.",
            equipment: .barbell,
            gifName: "bent_over_row",
            targetMuscles: "Back / Biceps",
            sfSymbolFallback: "figure.rowing"
        ),
        Exercise(
            name: "Reverse Lunge",
            description: "Dumbbells at sides. Step back into lunge, knee just above floor. Alternate legs.",
            equipment: .dumbbells,
            gifName: "reverse_lunge",
            targetMuscles: "Legs / Glutes",
            sfSymbolFallback: "figure.walk"
        ),
        Exercise(
            name: "Clean & Press",
            description: "Kettlebell from floor to shoulder (clean), then press overhead. Alternate sides.",
            equipment: .kettlebell,
            gifName: "clean_and_press",
            targetMuscles: "Shoulders / Full Body",
            sfSymbolFallback: "figure.strengthtraining.functional"
        ),
        Exercise(
            name: "Dumbbell Thruster",
            description: "Dumbbells at shoulders. Squat down, then drive up and press overhead in one motion.",
            equipment: .dumbbells,
            gifName: "dumbbell_thruster",
            targetMuscles: "Full Body / Cardio",
            sfSymbolFallback: "figure.highintensity.intervaltraining"
        ),
        Exercise(
            name: "Sumo Deadlift",
            description: "Wide stance, kettlebell between feet. Keep chest up, drive through heels to stand.",
            equipment: .kettlebell,
            gifName: "sumo_deadlift",
            targetMuscles: "Legs / Back",
            sfSymbolFallback: "figure.strengthtraining.traditional"
        ),
        Exercise(
            name: "Renegade Row",
            description: "Plank on dumbbells. Row one dumbbell up, stabilize with core. Alternate sides.",
            equipment: .dumbbells,
            gifName: "renegade_row",
            targetMuscles: "Core / Back",
            sfSymbolFallback: "figure.core.training"
        ),
    ]

    // MARK: - Pilates & Yoga (50s hold / 10s transition)

    static let pilatesYogaExercises: [Exercise] = [
        Exercise(
            name: "Cat-Cow Flow",
            description: "On all fours. Inhale: arch back, look up (cow). Exhale: round spine, tuck chin (cat).",
            equipment: .bodyweight,
            gifName: "cat_cow",
            targetMuscles: "Spine Mobility",
            sfSymbolFallback: "figure.mind.and.body"
        ),
        Exercise(
            name: "Downward Dog",
            description: "Inverted V shape. Push hips up and back, heels toward floor. Pedal feet to loosen.",
            equipment: .bodyweight,
            gifName: "downward_dog",
            targetMuscles: "Full Body Stretch",
            sfSymbolFallback: "figure.yoga"
        ),
        Exercise(
            name: "Warrior I",
            description: "Front knee bent 90°, back leg straight. Arms overhead. Switch sides halfway.",
            equipment: .bodyweight,
            gifName: "warrior_one",
            targetMuscles: "Hip Flexors / Balance",
            sfSymbolFallback: "figure.yoga"
        ),
        Exercise(
            name: "Warrior II",
            description: "Wide stance, front knee over ankle. Arms extended wide. Gaze over front hand. Switch halfway.",
            equipment: .bodyweight,
            gifName: "warrior_two",
            targetMuscles: "Hip Opening / Legs",
            sfSymbolFallback: "figure.yoga"
        ),
        Exercise(
            name: "Pilates Hundred",
            description: "Legs at 45°, head and shoulders up. Pump arms vigorously. Breathe: 5 counts in, 5 out.",
            equipment: .bodyweight,
            gifName: "pilates_hundred",
            targetMuscles: "Core Activation",
            sfSymbolFallback: "figure.pilates"
        ),
        Exercise(
            name: "Bridge Pose",
            description: "Lie on back, feet flat. Lift hips high, squeeze glutes. Hold or pulse gently.",
            equipment: .bodyweight,
            gifName: "bridge_pose",
            targetMuscles: "Glutes / Spine",
            sfSymbolFallback: "figure.pilates"
        ),
        Exercise(
            name: "Pilates Swimming",
            description: "Lie face down, arms forward. Lift opposite arm and leg, alternate quickly. Keep core tight.",
            equipment: .bodyweight,
            gifName: "pilates_swimming",
            targetMuscles: "Back / Core",
            sfSymbolFallback: "figure.pilates"
        ),
        Exercise(
            name: "Pigeon Pose",
            description: "Front shin across mat, back leg extended. Fold forward over front leg. Switch halfway.",
            equipment: .bodyweight,
            gifName: "pigeon_pose",
            targetMuscles: "Hip Stretch",
            sfSymbolFallback: "figure.yoga"
        ),
        Exercise(
            name: "Seated Spinal Twist",
            description: "Sit tall, cross one leg over other. Twist toward bent knee. Switch sides halfway.",
            equipment: .bodyweight,
            gifName: "spinal_twist",
            targetMuscles: "Spine Mobility",
            sfSymbolFallback: "figure.mind.and.body"
        ),
        Exercise(
            name: "Child's Pose",
            description: "Knees wide, big toes touching. Reach arms forward, forehead to mat. Breathe deeply.",
            equipment: .bodyweight,
            gifName: "childs_pose",
            targetMuscles: "Recovery / Stretch",
            sfSymbolFallback: "figure.cooldown"
        ),
    ]

    // MARK: - Workout Programs

    static let strengthWorkout = Workout(
        type: .strength,
        exercises: strengthExercises,
        workDuration: 40,
        restDuration: 15,
        introDuration: 5
    )

    static let pilatesYogaWorkout = Workout(
        type: .pilatesYoga,
        exercises: pilatesYogaExercises,
        workDuration: 50,
        restDuration: 10,
        introDuration: 5
    )

    static let allWorkouts: [Workout] = [strengthWorkout, pilatesYogaWorkout]
}

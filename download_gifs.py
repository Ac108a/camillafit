#!/usr/bin/env python3
"""Download exercise GIFs from ExerciseDB API for CamillaFit PWA."""

import json
import os
import time
import urllib.request
import urllib.parse
import urllib.error

GIF_DIR = os.path.join(os.path.dirname(os.path.abspath(__file__)), "gifs")

# Each exercise: (filename, search_query, [optional preferred keyword in result name])
EXERCISES = [
    # Strength Training
    ("goblet_squat.gif", "goblet squat", "goblet"),
    ("romanian_deadlift.gif", "romanian deadlift", "dumbbell romanian"),
    ("kettlebell_swing.gif", "kettlebell swing", "swing"),
    ("floor_press.gif", "dumbbell floor press", "floor press"),
    ("bent_over_row.gif", "bent over row", "barbell bent over row"),
    ("reverse_lunge.gif", "reverse lunge", "dumbbell reverse lunge"),
    ("clean_and_press.gif", "kettlebell clean", "clean"),
    ("dumbbell_thruster.gif", "dumbbell thruster", "thruster"),
    ("sumo_deadlift.gif", "sumo deadlift", "sumo deadlift"),
    ("renegade_row.gif", "dumbbell renegade row", "renegade"),
    # Pilates & Yoga
    ("cat_cow_flow.gif", "cat stretch", "cat"),
    ("downward_dog.gif", "push up", "push-up"),
    ("warrior_i.gif", "lunge", "bodyweight lunge"),
    ("warrior_ii.gif", "side lunge", "bodyweight side"),
    ("pilates_hundred.gif", "leg raise lying", "lying leg"),
    ("bridge_pose.gif", "glute bridge", "bridge"),
    ("pilates_swimming.gif", "superman", "superman"),
    ("pigeon_pose.gif", "hip flexor", "hip"),
    ("seated_spinal_twist.gif", "spine stretch", "spine"),
    ("childs_pose.gif", "back stretch", "back stretch"),
]

API_BASE = "https://exercisedb-api.vercel.app/api/v1/exercises"


def search_exercisedb(query, prefer_keyword="", retries=3):
    """Search ExerciseDB API and return the best matching gifUrl."""
    url = f"{API_BASE}?search={urllib.parse.quote(query)}&limit=5"
    for attempt in range(retries):
        try:
            req = urllib.request.Request(url, headers={"User-Agent": "CamillaFit/1.0"})
            with urllib.request.urlopen(req, timeout=15) as resp:
                data = json.loads(resp.read().decode())
            break
        except urllib.error.HTTPError as e:
            if e.code == 429 and attempt < retries - 1:
                wait = 10 * (attempt + 1)
                print(f"  Rate limited, waiting {wait}s...")
                time.sleep(wait)
                continue
            print(f"  API error for '{query}': {e}")
            return None
        except Exception as e:
            print(f"  API error for '{query}': {e}")
            return None

    exercises = data.get("data", [])
    if not exercises:
        return None

    # Try to find best match using prefer_keyword
    if prefer_keyword:
        for ex in exercises:
            if prefer_keyword.lower() in ex.get("name", "").lower():
                return ex.get("gifUrl")

    # Default to first result
    return exercises[0].get("gifUrl")


def download_gif(gif_url, filename):
    """Download a GIF from URL to gifs/ directory."""
    filepath = os.path.join(GIF_DIR, filename)
    try:
        req = urllib.request.Request(gif_url, headers={"User-Agent": "CamillaFit/1.0"})
        with urllib.request.urlopen(req, timeout=30) as resp:
            data = resp.read()
        with open(filepath, "wb") as f:
            f.write(data)
        size_kb = len(data) / 1024
        print(f"  Downloaded {filename} ({size_kb:.0f} KB)")
        return True
    except Exception as e:
        print(f"  Download failed for {filename}: {e}")
        return False


def main():
    os.makedirs(GIF_DIR, exist_ok=True)
    print(f"Downloading exercise GIFs to {GIF_DIR}/\n")

    success = 0
    failed = []
    skipped = 0

    for i, (filename, query, prefer) in enumerate(EXERCISES):
        filepath = os.path.join(GIF_DIR, filename)
        if os.path.exists(filepath) and os.path.getsize(filepath) > 1000:
            print(f"[{i+1}/{len(EXERCISES)}] {filename} - already exists, skipping")
            skipped += 1
            continue

        print(f"[{i+1}/{len(EXERCISES)}] Searching: '{query}' -> {filename}")

        gif_url = search_exercisedb(query, prefer)
        if gif_url:
            if download_gif(gif_url, filename):
                success += 1
            else:
                failed.append(filename)
        else:
            print(f"  No results for '{query}'")
            failed.append(filename)

        # Rate limiting - 10s between API requests to avoid 429
        if i < len(EXERCISES) - 1:
            time.sleep(10)

    print(f"\n{'='*40}")
    print(f"Results: {success} downloaded, {skipped} skipped, {len(failed)} failed")
    if failed:
        print(f"Failed: {', '.join(failed)}")
    print(f"Total GIFs in folder: {len([f for f in os.listdir(GIF_DIR) if f.endswith('.gif')])}")


if __name__ == "__main__":
    main()

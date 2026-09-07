# Jayajit Dutta — Developer Portfolio

A production-quality personal portfolio built with **Flutter**, showcasing
9+ years of experience as a Senior Mobile Application Developer (Android &
Flutter). Runs as a single Flutter codebase across **Web, Android, iOS,
Windows, macOS and Linux**, and auto-deploys to **GitHub Pages**.

All content is sourced directly from `Jayajit_Dutta_CV.pdf` and centralized
in one file: `lib/data/profile_data.dart`.

---

## 1. One-time setup (do this first)

This repository ships the Dart/Flutter source (`lib/`) and the web
scaffold (`web/`), but **not** the native `android/`, `ios/`, `macos/`,
`windows/` and `linux/` platform folders — those are large, auto-generated
by the Flutter CLI and are best created fresh on your machine. Since the
project's Dart source is already namespaced as `jayajit_portfolio`,
generate them like this:

```bash
flutter create --project-name jayajit_portfolio --org com.jayajitdutta --platforms android,ios,macos,windows,linux,web .
```

This will **not** overwrite `lib/`, `pubspec.yaml`, `test/`, or the
`web/index.html` / `web/manifest.json` files already in the repo — it only
adds the missing native platform folders and default icon/launch assets.

Then fetch dependencies:

```bash
flutter pub get
```

## 2. Run locally

```bash
flutter run -d chrome      # Web
flutter run -d macos       # macOS (or windows / linux)
flutter run                # Connected Android/iOS device or emulator
```

## 3. Editing your content

**You never need to touch UI code to update your resume content.** Everything
— name, summary, skills, experience, projects, education, links — lives in:

```
lib/data/profile_data.dart
```

Two placeholders you should fill in there before publishing:

```dart
static const String linkedInUrl = 'https://www.linkedin.com/in/REPLACE_ME';
static const String githubUrl = 'https://github.com/REPLACE_ME';
```

The bundled resume PDF used by the "Download Resume" buttons lives at:

```
assets/resume/Jayajit_Dutta_CV.pdf
```

Replace this file (keep the same name, or update
`ProfileData.resumeAssetPath` / `resumeDownloadFileName`) whenever your
resume is updated — the download button works on Web (browser download),
and on Android/iOS/desktop (opens with the OS default viewer / share sheet).

## 4. Project structure

```
lib/
  core/
    theme/            # Colors, light & dark ThemeData
    utils/             # Responsive breakpoints, url launcher, resume download
  data/
    models/            # Plain data classes (Project, ExperienceItem, ...)
    profile_data.dart  # <-- single source of truth for all content
  presentation/
    pages/             # HomePage (assembles all sections)
    state/             # ThemeController (light/dark toggle)
    widgets/
      common/          # NavBar, buttons, section wrapper, hover card
      sections/        # Hero, About, Skills, Experience, Projects, ...
```

## 5. Building for each platform

```bash
flutter build web --release          # -> build/web
flutter build apk --release          # -> build/app/outputs/flutter-apk
flutter build ios --release          # -> requires Xcode/macOS
flutter build windows --release
flutter build macos --release
flutter build linux --release
```

## 6. Deploying to GitHub Pages (automatic)

This repo includes `.github/workflows/deploy.yml`, which builds the Flutter
Web app and deploys `build/web` to GitHub Pages on every push to `main`.

**One-time GitHub setup:**

1. Push this repository to GitHub.
2. Go to **Settings → Pages**.
3. Under **Build and deployment → Source**, choose **GitHub Actions**.
4. Push to `main` (or run the workflow manually from the **Actions** tab).

The workflow automatically detects the correct `--base-href`:
- Project page (`https://<user>.github.io/<repo>/`) → `/<repo>/`
- User/org page repo named `<user>.github.io` → `/`

Your site will be live at the URL shown in **Settings → Pages** after the
workflow finishes (usually 1–2 minutes).

### Custom domain

1. Add a `CNAME` file inside `web/` containing your domain, e.g.:
   ```
   jayajitdutta.dev
   ```
   (Flutter copies everything in `web/` into `build/web/` on build, so it
   will be deployed automatically.)
2. In **Settings → Pages → Custom domain**, enter the same domain.
3. Point your domain's DNS to GitHub Pages (A records to GitHub's IPs, or a
   `CNAME` record to `<user>.github.io` for a subdomain) — see GitHub's
   ["Managing a custom domain"](https://docs.github.com/pages/configuring-a-custom-domain-for-your-github-pages-site)
   guide.
4. Once verified, set `web/index.html`'s `<base href>` build flag to `/`
   by updating the workflow's base-href step if needed (a custom domain at
   the root always uses `/`).

## 7. SEO

`web/index.html` already includes title, meta description, Open Graph and
Twitter Card tags, plus `web/robots.txt` and `web/sitemap.xml`. After you
know your final Pages/custom-domain URL, update the placeholder URLs inside
`robots.txt` and `sitemap.xml`.

## 8. Notes

- Built with Material 3, `google_fonts` (Inter / Plus Jakarta Sans),
  light/dark theme toggle, and responsive breakpoints for mobile, tablet,
  laptop, desktop and ultrawide.
- No fabricated companies, projects, dates, or metrics — everything is
  sourced from the resume. Any field the resume didn't cover (e.g. some
  project architecture/challenge details) is shown as a clearly marked
  `TODO:` placeholder in the project detail dialog instead of being
  invented.

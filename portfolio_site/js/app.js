/**
 * JAYAJIT DUTTA - SENIOR MOBILE DEVELOPER PORTFOLIO
 * High-Performance Vanilla JavaScript Logic:
 * 1. Instant Render & Ambient Particle Canvas
 * 2. Dynamic Tech Stack Text Changing Effect
 * 3. Sticky Navbar Blur & Shrink on Scroll
 * 4. IntersectionObserver Scroll Reveals (.reveal -> .active)
 * 5. Interactive Project Filtering
 * 6. Tactile Clipboard Copy & Native Toast
 */

document.addEventListener('DOMContentLoaded', () => {
  initParticleCanvas();
  initDynamicText();
  initStickyNavbar();
  initScrollReveals();
  initProjectFilters();
  initClipboardAndToasts();
  initMobileDrawer();
  initNavScrollSpy();
});

/* ==========================================================================
   1. Ambient Canvas Particle Mesh (Hero Background)
   Subtle, non-distracting, high-performance 60fps
   ========================================================================== */
function initParticleCanvas() {
  const canvas = document.getElementById('particleCanvas');
  if (!canvas) return;

  const ctx = canvas.getContext('2d');
  let width = (canvas.width = window.innerWidth);
  let height = (canvas.height = window.innerHeight);

  const particles = [];
  const particleCount = Math.min(Math.floor((width * height) / 22000), 55);

  class Particle {
    constructor() {
      this.reset();
    }

    reset() {
      this.x = Math.random() * width;
      this.y = Math.random() * height;
      this.vx = (Math.random() - 0.5) * 0.45;
      this.vy = (Math.random() - 0.5) * 0.45;
      this.radius = Math.random() * 1.8 + 0.8;
      this.alpha = Math.random() * 0.4 + 0.15;
    }

    update() {
      this.x += this.vx;
      this.y += this.vy;

      if (this.x < 0) this.x = width;
      if (this.x > width) this.x = 0;
      if (this.y < 0) this.y = height;
      if (this.y > height) this.y = 0;
    }

    draw() {
      ctx.beginPath();
      ctx.arc(this.x, this.y, this.radius, 0, Math.PI * 2);
      ctx.fillStyle = `rgba(56, 189, 248, ${this.alpha})`;
      ctx.fill();
    }
  }

  for (let i = 0; i < particleCount; i++) {
    particles.push(new Particle());
  }

  function drawConnections() {
    const maxDist = 130;
    for (let i = 0; i < particles.length; i++) {
      for (let j = i + 1; j < particles.length; j++) {
        const dx = particles[i].x - particles[j].x;
        const dy = particles[i].y - particles[j].y;
        const dist = Math.sqrt(dx * dx + dy * dy);

        if (dist < maxDist) {
          const alpha = (1 - dist / maxDist) * 0.15;
          ctx.beginPath();
          ctx.moveTo(particles[i].x, particles[i].y);
          ctx.lineTo(particles[j].x, particles[j].y);
          ctx.strokeStyle = `rgba(99, 102, 241, ${alpha})`;
          ctx.lineWidth = 0.8;
          ctx.stroke();
        }
      }
    }
  }

  let animationFrameId;
  function animate() {
    ctx.clearRect(0, 0, width, height);
    for (let i = 0; i < particles.length; i++) {
      particles[i].update();
      particles[i].draw();
    }
    drawConnections();
    animationFrameId = requestAnimationFrame(animate);
  }

  animate();

  // Optimized resize handler
  let resizeTimeout;
  window.addEventListener('resize', () => {
    clearTimeout(resizeTimeout);
    resizeTimeout = setTimeout(() => {
      width = canvas.width = window.innerWidth;
      height = canvas.height = window.innerHeight;
    }, 150);
  });
}

/* ==========================================================================
   2. Dynamic Text Changing Effect (Tech Stack Swapper)
   Requirement: swapping between 'Android', 'Flutter', 'Kotlin'
   ========================================================================== */
function initDynamicText() {
  const textElement = document.getElementById('dynamicStackText');
  if (!textElement) return;

  const roles = [
    'Android & Kotlin',
    'Jetpack Compose',
    'Flutter & Riverpod',
    'Clean Architecture',
    'Coroutines & Flow',
    'Offline-First Sync'
  ];

  let currentIndex = 0;
  let isDeleting = false;
  let currentText = '';
  let typingSpeed = 100;

  function typeCycle() {
    const fullText = roles[currentIndex];

    if (isDeleting) {
      currentText = fullText.substring(0, currentText.length - 1);
      typingSpeed = 50;
    } else {
      currentText = fullText.substring(0, currentText.length + 1);
      typingSpeed = 110;
    }

    textElement.textContent = currentText;

    if (!isDeleting && currentText === fullText) {
      // Pause on full word
      typingSpeed = 2000;
      isDeleting = true;
    } else if (isDeleting && currentText === '') {
      isDeleting = false;
      currentIndex = (currentIndex + 1) % roles.length;
      typingSpeed = 400;
    }

    setTimeout(typeCycle, typingSpeed);
  }

  typeCycle();
}

/* ==========================================================================
   3. Sticky Navbar Blur & Shrink on Scroll
   Requirement: top navigation bar becomes blurred and shrinks in height
   ========================================================================== */
function initStickyNavbar() {
  const navbar = document.getElementById('mainNavbar');
  if (!navbar) return;

  const checkScroll = () => {
    if (window.scrollY > 25) {
      navbar.classList.add('scrolled');
    } else {
      navbar.classList.remove('scrolled');
    }
  };

  window.addEventListener('scroll', checkScroll, { passive: true });
  checkScroll(); // Initial check
}

/* ==========================================================================
   4. Scroll Reveals via IntersectionObserver
   Requirement: smoothly fade in and translate upwards by 20px
   ========================================================================== */
function initScrollReveals() {
  const revealElements = document.querySelectorAll('.reveal');
  if (!revealElements.length) return;

  if ('IntersectionObserver' in window) {
    const observerOptions = {
      root: null,
      rootMargin: '0px 0px -80px 0px',
      threshold: 0.12
    };

    const revealObserver = new IntersectionObserver((entries, observer) => {
      entries.forEach(entry => {
        if (entry.isIntersecting) {
          entry.target.classList.add('active');
          // Once revealed, no need to keep observing
          observer.unobserve(entry.target);
        }
      });
    }, observerOptions);

    revealElements.forEach(el => revealObserver.observe(el));
  } else {
    // Fallback for older browsers
    revealElements.forEach(el => el.classList.add('active'));
  }
}

/* ==========================================================================
   5. Interactive Project Category Filtering
   ========================================================================== */
function initProjectFilters() {
  const filterBtns = document.querySelectorAll('.filter-btn');
  const projectCards = document.querySelectorAll('.project-card');

  if (!filterBtns.length || !projectCards.length) return;

  filterBtns.forEach(btn => {
    btn.addEventListener('click', () => {
      // Update active state
      filterBtns.forEach(b => b.classList.remove('active'));
      btn.classList.add('active');

      const filter = btn.getAttribute('data-filter');

      projectCards.forEach(card => {
        const category = card.getAttribute('data-category');
        if (filter === 'all' || category === filter) {
          card.style.display = 'flex';
          setTimeout(() => {
            card.style.opacity = '1';
            card.style.transform = 'translateY(0)';
          }, 10);
        } else {
          card.style.opacity = '0';
          card.style.transform = 'translateY(15px)';
          setTimeout(() => {
            card.style.display = 'none';
          }, 250);
        }
      });
    });
  });
}

/* ==========================================================================
   6. Tactile Clipboard Copy & Toast Notifications
   ========================================================================== */
function initClipboardAndToasts() {
  const copyButtons = [
    document.getElementById('copyEmailHeroBtn'),
    document.getElementById('copyEmailFooterBtn')
  ];

  const toast = document.getElementById('toastNotification');
  const toastMessage = document.getElementById('toastMessage');
  let toastTimer;

  function showToast(message) {
    if (!toast) return;
    if (toastMessage) toastMessage.textContent = message;

    toast.classList.add('visible');
    clearTimeout(toastTimer);
    toastTimer = setTimeout(() => {
      toast.classList.remove('visible');
    }, 3200);
  }

  copyButtons.forEach(btn => {
    if (!btn) return;
    btn.addEventListener('click', async (e) => {
      e.preventDefault();
      const email = btn.getAttribute('data-email') || 'jayajit1989@gmail.com';

      try {
        if (navigator.clipboard && navigator.clipboard.writeText) {
          await navigator.clipboard.writeText(email);
        } else {
          // Fallback
          const tempInput = document.createElement('textarea');
          tempInput.value = email;
          document.body.appendChild(tempInput);
          tempInput.select();
          document.execCommand('copy');
          document.body.removeChild(tempInput);
        }
        showToast(`Copied ${email} to clipboard!`);
      } catch (err) {
        showToast(`Email: ${email}`);
      }
    });
  });
}

/* ==========================================================================
   7. Mobile Navigation Drawer Toggle
   ========================================================================== */
function initMobileDrawer() {
  const toggleBtn = document.getElementById('menuToggleBtn');
  const drawer = document.getElementById('mobileDrawer');
  const links = document.querySelectorAll('.mobile-link');

  if (!toggleBtn || !drawer) return;

  const toggle = () => {
    const isOpen = drawer.classList.contains('open');
    if (isOpen) {
      drawer.classList.remove('open');
      toggleBtn.classList.remove('open');
      toggleBtn.setAttribute('aria-expanded', 'false');
    } else {
      drawer.classList.add('open');
      toggleBtn.classList.add('open');
      toggleBtn.setAttribute('aria-expanded', 'true');
    }
  };

  toggleBtn.addEventListener('click', toggle);

  links.forEach(link => {
    link.addEventListener('click', () => {
      drawer.classList.remove('open');
      toggleBtn.classList.remove('open');
      toggleBtn.setAttribute('aria-expanded', 'false');
    });
  });
}

/* ==========================================================================
   8. Nav Scroll Spy (Highlights active section in navbar)
   ========================================================================== */
function initNavScrollSpy() {
  const sections = document.querySelectorAll('section[id]');
  const navLinks = document.querySelectorAll('.nav-link');

  if (!sections.length || !navLinks.length) return;

  window.addEventListener('scroll', () => {
    let currentId = '';
    const scrollPos = window.scrollY + 120;

    sections.forEach(section => {
      const top = section.offsetTop;
      const height = section.offsetHeight;
      if (scrollPos >= top && scrollPos < top + height) {
        currentId = section.getAttribute('id');
      }
    });

    navLinks.forEach(link => {
      link.classList.remove('active');
      if (link.getAttribute('href') === `#${currentId}`) {
        link.classList.add('active');
      }
    });
  }, { passive: true });
}

// 34Wiki Branding Script - Replace "Outline" text with "34Wiki" and purple logo with yellow "34" logo
(function () {
    function applyBranding() {
        let changes = 0;

        // Replace text in all text nodes
        const walker = document.createTreeWalker(
            document.body,
            NodeFilter.SHOW_TEXT,
            null,
            false
        );

        const nodes = [];
        while (walker.nextNode()) {
            nodes.push(walker.currentNode);
        }

        nodes.forEach(node => {
            if (node.nodeValue && node.nodeValue.includes('Outline')) {
                node.nodeValue = node.nodeValue.replace(/Outline/g, '34Wiki');
                changes++;
            }
        });

        // Replace the purple "O" logo with the yellow "34" logo
        const logoDiv = document.querySelector('[alt="Logo"]');
        if (logoDiv && logoDiv.tagName === 'DIV') {
            const img = document.createElement('img');
            img.src = '/assets/logo.png';
            img.alt = '34Wiki Logo';
            img.style.width = '24px';
            img.style.height = '24px';
            img.style.borderRadius = '50%';
            logoDiv.parentNode.replaceChild(img, logoDiv);
            changes++;
        }

        // Target the specific button element that contains "Outline"
        const button = document.querySelector('[aria-label="Account"]');
        if (button && button.textContent.includes('Outline')) {
            button.innerHTML = button.innerHTML.replace(/Outline/g, '34Wiki');
            changes++;
        }

        if (changes > 0) {
            console.log('34Wiki branding applied, changes made:', changes);
        }
    }

    // Expose function globally for testing
    window.applyBranding = applyBranding;

    // Run after a delay to allow React to render
    function delayedApply() {
        setTimeout(applyBranding, 100);
        setTimeout(applyBranding, 500);
        setTimeout(applyBranding, 1000);
        setTimeout(applyBranding, 2000);
        setTimeout(applyBranding, 3000);
    }

    // Run when DOM is ready
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', delayedApply);
    } else {
        delayedApply();
    }

    // Watch for dynamic changes with debouncing
    let timeout;
    const observer = new MutationObserver(() => {
        clearTimeout(timeout);
        timeout = setTimeout(applyBranding, 100);
    });

    if (document.body) {
        observer.observe(document.body, {
            childList: true,
            subtree: true,
            characterData: true
        });
    } else {
        // If body doesn't exist yet, wait for it
        document.addEventListener('DOMContentLoaded', () => {
            observer.observe(document.body, {
                childList: true,
                subtree: true,
                characterData: true
            });
        });
    }
})();

function goToPage(page) {
    window.location.href = page;
}

function goBack() {
    window.history.back();
}

function filterServices(searchTerm) {
    const allCards = document.querySelectorAll('.service-card, .category-card');
    
    allCards.forEach(card => {
        const titleElement = card.querySelector('.service-title, .category-title');
        const subtitleElement = card.querySelector('.category-subtitle');
        
        const title = titleElement ? titleElement.textContent.toLowerCase() : '';
        const subtitle = subtitleElement ? subtitleElement.textContent.toLowerCase() : '';
        
        if (title.includes(searchTerm) || subtitle.includes(searchTerm) || searchTerm === '') {
            card.style.display = 'flex';
            card.style.animation = 'fadeIn 0.3s ease-out';
        } else {
            card.style.display = 'none';
        }
    });
}

function toggleReportFab(show = true) {
    const fab = document.querySelector('.new-report-fab');
    if (fab) {
        fab.style.display = show ? 'flex' : 'none';
    }
}

document.addEventListener('DOMContentLoaded', function() {
    const searchInput = document.getElementById('serviceSearch');
    if (searchInput) {
        searchInput.addEventListener('input', function() {
            const searchTerm = this.value.toLowerCase();
            filterServices(searchTerm);
        });
    }
    
    const reportSearchInput = document.getElementById('reportSearch');
    if (reportSearchInput) {
        reportSearchInput.addEventListener('input', function() {
            const searchTerm = this.value.toLowerCase();
            filterReports(searchTerm);
        });
    }
    
    const currentPage = window.location.pathname;
    if (currentPage.includes('new-report.html') || 
        currentPage.includes('summary.html')) {
        toggleReportFab(false);
    } else {
        toggleReportFab(true);
    }
    
    window.addEventListener('scroll', handleScrollEffect);
});


function handleScrollEffect() {
    const fab = document.querySelector('.new-report-fab');
    if (fab && fab.style.display !== 'none') {
        if (window.scrollY > 100) {
            fab.style.transform = 'scale(0.9)';
            fab.style.opacity = '0.9';
        } else {
            fab.style.transform = 'scale(1)';
            fab.style.opacity = '1';
        }
    }
}

function filterReports(searchTerm) {
    const reports = document.querySelectorAll('.report-card, .report-card-compact');
    
    reports.forEach(report => {
        const description = report.querySelector('.report-description')?.textContent.toLowerCase() || '';
        const number = report.querySelector('.report-number')?.textContent.toLowerCase() || '';
        const entity = report.querySelector('.report-entity')?.textContent.toLowerCase() || '';
        
        if (description.includes(searchTerm) || 
            number.includes(searchTerm) || 
            entity.includes(searchTerm) || 
            searchTerm === '') {
            report.style.display = 'block';
            report.style.animation = 'fadeIn 0.3s ease-out';
        } else {
            report.style.display = 'none';
        }
    });
}


function removeImage(index) {
    const previewContainer = document.getElementById('imagePreview');
    const images = document.querySelectorAll('.preview-item');
    
    if (images[index]) {
        images[index].remove();
    }
    
    const fileInput = document.getElementById('imageUpload');
    const dt = new DataTransfer();
    const files = Array.from(fileInput.files);
    
    files.splice(index, 1);
    files.forEach(file => dt.items.add(file));
    fileInput.files = dt.files;
}

function handleImageUpload(event) {
    const files = event.target.files;
    const previewContainer = document.getElementById('imagePreview');
    
    for (let i = 0; i < files.length; i++) {
        const file = files[i];
        if (file.type.startsWith('image/')) {
            const reader = new FileReader();
            
            reader.onload = function(e) {
                const previewItem = document.createElement('div');
                previewItem.className = 'preview-item';
                previewItem.innerHTML = `
                    <img src="${e.target.result}" alt="صورة البلاغ">
                    <button type="button" class="remove-image" onclick="removeImage(${previewContainer.children.length})">
                        <i class="fas fa-times"></i>
                    </button>
                `;
                previewContainer.appendChild(previewItem);
            }
            
            reader.readAsDataURL(file);
        }
    }
}

function triggerImageUpload() {
    document.getElementById('imageUpload').click();
}

async function suggestReportType() {
    const description = document.getElementById('reportDescription').value;
    const typeSuggestion = document.getElementById('typeSuggestion');
    
    if (!description.trim()) {
        typeSuggestion.innerHTML = `
            <i class="fas fa-robot"></i>
            <div class="suggestion-text">
                <span class="suggestion-title">يتم اقتراح نوع البلاغ تلقائياً...</span>
                <span class="suggestion-subtitle">التقرير والبلاغ</span>
            </div>
        `;
        return;
    }
    
    typeSuggestion.innerHTML = `
        <i class="fas fa-spinner fa-spin"></i>
        <div class="suggestion-text">
            <span class="suggestion-title">جاري التحليل...</span>
            <span class="suggestion-subtitle">التقرير والبلاغ</span>
        </div>
    `;
    
    const analysis = await analyzeTextWithAI(description);
    
    if (analysis && analysis.type !== 'other') {
        const typeNames = {
            'fire': 'حريق',
            'water': 'تسرب مياه',
            'electricity': 'أعطال كهربائية',
            'road': 'أعطال طرق',
            'sanitation': 'نظافة وصرف صحي'
        };
        
        const typeName = typeNames[analysis.type] || analysis.type;
        
        typeSuggestion.innerHTML = `
            <i class="fas fa-check-circle"></i>
            <div class="suggestion-text">
                <span class="suggestion-title">تم اقتراح: ${typeName}</span>
                <span class="suggestion-subtitle">التقرير والبلاغ</span>
            </div>
        `;
        
        document.getElementById('reportType').value = analysis.type;
        updateSuggestedEntity();
    }
}

function updateSuggestedEntity() {
    const reportType = document.getElementById('reportType').value;
    const entitySuggestion = document.getElementById('entitySuggestion');
    
    if (!reportType) {
        entitySuggestion.innerHTML = `
            <i class="fas fa-robot"></i>
            <div class="suggestion-text">
                <span class="suggestion-title">يتم اقتراح الجهة تلقائياً...</span>
                <span class="suggestion-subtitle">التقرير الجهة المختصة</span>
            </div>
        `;
        return;
    }
    
    const entityMap = {
        'fire': { name: 'الدفاع المدني', icon: 'fa-fire-extinguisher' },
        'water': { name: 'شركة المياه الوطنية', icon: 'fa-tint' },
        'electricity': { name: 'شركة الكهرباء', icon: 'fa-bolt' },
        'road': { name: 'البلدية', icon: 'fa-road' },
        'sanitation': { name: 'البلدية', icon: 'fa-trash' }
    };
    
    const entity = entityMap[reportType] || { name: 'البلدية', icon: 'fa-building' };
    
    entitySuggestion.innerHTML = `
        <i class="fas ${entity.icon}"></i>
        <div class="suggestion-text">
            <span class="suggestion-title">تم اقتراح: ${entity.name}</span>
            <span class="suggestion-subtitle">التقرير الجهة المختصة</span>
        </div>
    `;
    
    const entityValues = {
        'fire': 'civil_defense',
        'water': 'water_company',
        'electricity': 'electricity_company',
        'road': 'municipality',
        'sanitation': 'municipality'
    };
    
    document.getElementById('reportEntity').value = entityValues[reportType] || 'municipality';
}

function getCurrentLocation() {
    const locationInput = document.getElementById('reportLocation');
    
    if (navigator.geolocation) {
        locationInput.value = 'جاري تحديد الموقع...';
        
        navigator.geolocation.getCurrentPosition(
            function(position) {
                const lat = position.coords.latitude;
                const lng = position.coords.longitude;
                locationInput.value = `الموقع الحالي: ${lat.toFixed(6)}, ${lng.toFixed(6)}`;
            },
            function(error) {
                locationInput.value = 'تعذر تحديد الموقع. الرجاء إدخاله يدوياً.';
                console.error('Geolocation error:', error);
            }
        );
    } else {
        locationInput.value = 'المتصفح لا يدعم تحديد الموقع.';
    }
}

function validateAndProceed() {
    const description = document.getElementById('reportDescription').value;
    const type = document.getElementById('reportType').value;
    const entity = document.getElementById('reportEntity').value;
    const location = document.getElementById('reportLocation').value;
    
    if (!description.trim()) {
        alert('الرجاء إدخال وصف للبلاغ');
        return;
    }
    
    if (!type) {
        alert('الرجاء اختيار نوع البلاغ');
        return;
    }
    
    if (!entity) {
        alert('الرجاء اختيار الجهة المختصة');
        return;
    }
    
    if (!location.trim()) {
        alert('الرجاء إدخال موقع الحادثة');
        return;
    }
    
    const reportData = {
        description: description,
        type: type,
        entity: entity,
        location: location,
        timestamp: new Date().toISOString(),
        images: Array.from(document.querySelectorAll('.preview-item img')).map(img => img.src)
    };
    
    localStorage.setItem('currentReport', JSON.stringify(reportData));
    
    goToPage('summary.html');
}


async function analyzeTextWithAI(text) {
    try {
        const response = await fetch('http://localhost:5000/api/analyze', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({ text: text })
        });
        
        const data = await response.json();
        return data;
    } catch (error) {
        console.error('AI analysis error:', error);
        return null;
    }
}

async function submitReportToServer(reportData) {
    try {
        const response = await fetch('http://localhost:5000/api/reports', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(reportData)
        });
        
        const data = await response.json();
        return data;
    } catch (error) {
        console.error('Submit error:', error);
        throw error;
    }
}

async function fetchPreviousReports() {
    try {
        const response = await fetch('http://localhost:5000/api/reports');
        const data = await response.json();
        return data.reports || [];
    } catch (error) {
        console.error('Fetch error:', error);
        return [];
    }
}


function triggerImageUpload(){
    document.getElementById("imageUpload").click();
}

function handleImageUpload(event){
    const files = event.target.files;
    const preview = document.getElementById("imagePreview");

    for(let file of files){
        const reader = new FileReader();
        reader.onload = e=>{
            let box=document.createElement("div");
            box.className="image-preview-item";

            box.innerHTML =
                `<img src="${e.target.result}">
                <button class="remove-image-btn">✕</button>`;

            box.querySelector("button").onclick=()=>box.remove();
            preview.appendChild(box);
        }
        reader.readAsDataURL(file);
    }
}

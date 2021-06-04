 require("BoxLib");
-- 屏幕常量
device.keepWake();
currentIndex = 1;
count = 0;

-- 查找广告按钮并点击
function findAdButtonAndClick()
    for i=1,3,1 do
        local titles = {"观看创意广告", "Watch creative ads"};
        for i = 1, #titles do
            local title = titles[i];
            local wid= widget.desc(title);
            if wid ~= nil then
                mSleep(1000)
                toast("控件已找到")
                mSleep(1000)
                --点击控件
                widget.click(wid)
                mSleep(1000)
                --点击控件
                widget.click(wid)
                mSleep(3000)
                return true;
            else
                mSleep(3000)
            end
        end
    end
    return false;
end

-- 点击
function tapAction()
    local num = getRndNum(1,10);
    if num == 6 then
        findOpenButtonAndClick()
    else 
        findCloseButtonAndClick()
    end
end

-- 查找打开按钮并点击
function findOpenButtonAndClick()
    toast("点击广告")
    local w,h = getScreenSize();
    event.tap(w / 2, h / 2);
    mSleep(3000);
    -- 检测应用是否打开
    local packageName = app.frontPackageName();
    local currentPackageName = currentPackage()
    if packageName ~= currentPackageName then
        app.runApp(currentPackageName);
        mSleep(3000);
    end
    findCloseButtonAndClick()
end

-- 查找关闭按钮并点击
function findCloseButtonAndClick()
    toast("查找关闭按钮")
    local result = false;
    local titles = {"关闭", "關閉", "Close", "返回", "back"};
    for i = 1, #titles do
        local title = titles[i];
        local wid= widget.text(title);
        if wid ~= nil then
            mSleep(1000)
            toast(title.."控件已找到"); 
            mSleep(1000)
            --点击控件
            widget.click(wid)
            mSleep(1000);
            widget.click(wid)
            mSleep(1000);
            result = true;
            break;
        end
    end

    wid= widget.id("close-button-icon");
    if wid ~= nil then
        mSleep(1000)
        toast("close-button-icon"); 
        mSleep(1000)
        --点击控件
        widget.click(wid)
        mSleep(1000)
        result = true;
    end

    if result == false then
        keycode.back();
        mSleep(3000)
    end
end

function getCurrentPage()
    local titles = {"运动", "Sports"};
    for i = 1, #titles do
        local title = titles[i];
        local wid = widget.desc(title);
        if wid ~= nil then
            return "运动";
        end
    end
    return nil;
end

function currentPackage()
    local apps = {
        "com.yk.sports", 
        "com.yk.health",
        "com.yk.run", 
        "com.yk.exercise", 
        "com.yk.climb",
        "com.yk.walk", 
        "com.yk.sports.vungle",  
        "com.yk.health.plus",  
        "com.yk.run.plus",  
        "com.yk.exercise.plus",
        "com.yk.climb.plus",
        "com.yk.walk.plus", 
    };
    local name = apps[currentIndex];
    if name == nil then
        currentIndex = 1;
        name = apps[currentIndex];
    end
    return name;
end

function start()
    mSleep(5000);
    local page = getCurrentPage();
    if page == "运动" then
        -- 查找广告按钮并点击
        local result = findAdButtonAndClick();
        if result == true then
            page = getCurrentPage();
            if page ~= "运动" then
                mSleep(getRndNum(25000, 30000));
                tapAction();
            end
            currentIndex = currentIndex + 1;
        else
            currentIndex = currentIndex + 1;
        end
    else
        toast("未知页面，返回");
        keycode.back();
        mSleep(2000)
    end
end

while true do
    -- 检测应用是否打开
    local packageName = app.frontPackageName();
    local currentPackageName = currentPackage()
    if packageName ~= currentPackageName then
        local flag = app.runApp(currentPackageName);
        if  flag == true then
            mSleep(5000);
            start();
        else
            currentIndex = currentIndex + 1;
        end
    else
        start();
    end
end

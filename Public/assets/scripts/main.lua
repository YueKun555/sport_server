require("BoxLib");
-- 屏幕常量
device.keepWake();
currentIndex = 1;
count = 0;
startCount = 0;

-- 查找广告按钮并点击
function findAdButtonAndClick()
    local titles = {"Watch creative ads"};
    for j = 1, #titles do
        local title = titles[j];
        local wid = widget.desc(title);
        if wid ~= nil then
            -- toast("控件已找到")
            mSleep(1000)
            --点击控件
            widget.click(wid)
            mSleep(3000)
            return true;
        else
            -- toast("没有找到控件")
            mSleep(3000)
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
    -- toast("点击广告")
    local w,h = getScreenSize();
    event.tap(w / 2, h / 2);
    mSleep(5000);
    -- 检测应用是否打开
    local packageName = app.frontPackageName();
    local currentPackageName = currentPackage()
    if packageName ~= currentPackageName then
        app.runApp(currentPackageName, true);
        mSleep(5000);
    end
    findCloseButtonAndClick()
end

-- 查找关闭按钮并点击
function findCloseButtonAndClick()
    -- toast("查找关闭按钮")
    local result = false;
    local titles = {"关闭", "關閉", "Close", "返回", "back"};
    for i = 1, #titles do
        local title = titles[i];
        local wid= widget.text(title);
        if wid ~= nil then
            mSleep(1000)
            -- toast(title.."控件已找到");
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
        -- toast("close-button-icon");
        mSleep(1000)
        --点击控件
        widget.click(wid)
        mSleep(1000)
        result = true;
    end

    if result == false then
        keycode.back();
        mSleep(3000)
        local page = getCurrentPage();
        if page ~= "运动" then
            local w,h = getScreenSize();
            event.tap(w - 60, 60);
        end
    end
end

function getCurrentPage()
    local titles = {"Sports"};
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
    -- toast(currentIndex);
    if currentIndex > 12 then
        currentIndex = 1;
    end
    local name = apps[currentIndex];
    return name;
end

function start()
    startCount = startCount + 1;
    if startCount > 3 then
        startCount = 0;
        currentIndex = currentIndex + 1;
    else
        mSleep(5000);
        local page = getCurrentPage();
        if page == "运动" then
            count = 0;
            -- 查找广告按钮并点击
            local result = findAdButtonAndClick();
            if result == true then
                page = getCurrentPage();
                if page ~= "运动" then
                    mSleep(getRndNum(30000, 40000));
                    tapAction();
                end
            else
                -- toast("切换app");
                currentIndex = currentIndex + 1;
            end
        else
            -- toast("未知页面，返回");
            keycode.back();
            mSleep(3000)
            if page ~= "运动" then
                local w,h = getScreenSize();
                event.tap(w - 60, 60);
            end
            count = count + 1;
            if count > 2 then
                count = 0;
                currentIndex = currentIndex + 1;
            end
        end
    end
end

while true do
    -- 检测应用是否打开
    local packageName = app.frontPackageName();
    local currentPackageName = currentPackage()
    if packageName ~= currentPackageName then
        local flag = app.runApp(currentPackageName, true);
        mSleep(5000);
        start();
    else
        start();
    end
end

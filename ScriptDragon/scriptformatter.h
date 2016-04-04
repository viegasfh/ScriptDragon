#ifndef SCRIPTFORMATTER_H
#define SCRIPTFORMATTER_H

#include <QObject>
#include <QQmlEngine>
#include <QQuickTextDocument>
#include <QTextBlockFormat>
#include <QTextBlockUserData>
#include <unordered_map>

class ScriptFormatter : public QObject
{
		Q_OBJECT
	public:
		explicit ScriptFormatter( QQmlEngine* newEngine = NULL, QObject *parent = 0 );
		
		enum paragraphType {
			SCENE,
			ACTION,
			CHARACTER,
			DIALOG,
			PARENTHETICAL,
			TRANSITION,
			SHOT,
			ACT_BREAK
		};
		Q_ENUMS( paragraphType );
		
		/*std::unordered_map<paragraphType, paragraphType> nextType = {
			{ SCENE, ACTION },
			{ ACTION, ACTION },
			{ CHARACTER, DIALOG },
			{ DIALOG, CHARACTER },
			{ PARENTHETICAL, DIALOG },
			{ TRANSITION, SCENE },
			{ SHOT, ACTION },
			{ ACT_BREAK, SCENE }
		};*/
		
		Q_INVOKABLE void setDefaultFontForDocument( QQuickTextDocument* document );
		
		Q_INVOKABLE void setParagraphType( QQuickTextDocument* document, paragraphType newType, int selectionStart, int selectionEnd );
		
		QFont sceneFont;
		QTextBlockFormat sceneBlockFormat;
		QFont actionFont;
		QTextBlockFormat actionBlockFormat;
		QFont characterFont;
		QTextBlockFormat characterBlockFormat;
		QFont dialogFont;
		QTextBlockFormat dialogBlockFormat;
		QFont parentheticalFont;
		QTextBlockFormat parentheticalBlockFormat;
		QFont transitionFont;
		QTextBlockFormat transitionBlockFormat;
		QFont shotFont;
		QTextBlockFormat shotBlockFormat;
		QFont actBreakFont;
		QTextBlockFormat actBreakBlockFormat;
		
		class typeTracker : public QTextBlockUserData {
			public:
				typeTracker( paragraphType newType = ACTION ) { type = newType; };
				paragraphType type;
		};
		
	signals:
		
	public slots:
		
	private:
		
};

//Define the singleton type provider function
static QObject* scriptFormatter_provider( QQmlEngine* newEngine, QJSEngine* scriptEngine ) {
	Q_UNUSED( scriptEngine )
	
	ScriptFormatter* sf = new ScriptFormatter( newEngine );
	return sf;
}

#endif // SCRIPTFORMATTER_H

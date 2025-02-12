#ifndef REPORTGENERATOR_H
#define REPORTGENERATOR_H

#include <QObject>
#include <QQuickTextDocument>
#include <QString>
#include <QTextDocument>
#include "scriptformatter.h"

class ReportGenerator : public QObject
{
		Q_OBJECT
	public:
		explicit ReportGenerator( QQmlEngine* newEngine = NULL, QObject *parent = 0 );
		
		Q_INVOKABLE QString generateReport( int numerator, int denominator ); //Both parameters should be of type ScriptFormatter::paragraphType. Had to make them ints for use with QML.
		
		Q_INVOKABLE void setScript( QQuickTextDocument* newScript );
		
		
		void actionsPerScene( QTextDocument* report );
		void charactersPerScene( QTextDocument* report );
		void dialogsPerScene( QTextDocument* report );
		void parentheticalsPerScene( QTextDocument* report );
		void transitionsPerScene( QTextDocument* report );
		void shotsPerScene( QTextDocument* report );
		void actBreaksPerScene( QTextDocument* report );
		void scenesPerAction( QTextDocument* report );
		void dialogsPerAction( QTextDocument* report );
		void charactersPerAction( QTextDocument* report );
		void parentheticalsPerAction( QTextDocument* report );
		void transitionsPerAction( QTextDocument* report );
		void shotsPerAction( QTextDocument* report );
		void actBreaksPerAction( QTextDocument* report );
		void scenesPerCharacter( QTextDocument* report );
		void actionsPerCharacter( QTextDocument* report );
		void dialogsPerCharacter( QTextDocument* report );
		void parentheticalsPerCharacter( QTextDocument* report );
		void transitionsPerCharacter( QTextDocument* report );
		void shotsPerCharacter( QTextDocument* report );
		void actBreaksPerCharacter( QTextDocument* report );
		void scenesPerDialog( QTextDocument* report );
		void actionsPerDialog( QTextDocument* report );
		void parentheticalsPerDialog( QTextDocument* report );
		void transitionsPerDialog( QTextDocument* report );
		void scenesPerParenthetical( QTextDocument* report );
		void actionsPerParenthetical( QTextDocument* report );
		void charactersPerParenthetical( QTextDocument* report );
		void dialogsPerParenthetical( QTextDocument* report );
		void transitionsPerParenthetical( QTextDocument* report );
		void shotsPerParenthetical( QTextDocument* report );
		void actBreaksPerParenthetical( QTextDocument* report );
		void scenesPerTransition( QTextDocument* report );
		void actionsPerTransition( QTextDocument* report );
		void charactersPerTransition( QTextDocument* report );
		void dialogsPerTransition( QTextDocument* report );
		void parentheticalsPerTransition( QTextDocument* report );
		void shotsPerTransition( QTextDocument* report );
		void actBreaksPerTransition( QTextDocument* report );
		void scenesPerShot( QTextDocument* report );
		void actionsPerShot( QTextDocument* report );
		void charactersPerShot( QTextDocument* report );
		void dialogsPerShot( QTextDocument* report );
		void parentheticalsPerShot( QTextDocument* report );
		void transitionsPerShot( QTextDocument* report );
		void actBreaksPerShot( QTextDocument* report );
		
	signals:
		
	public slots:
		
	private:
		QQuickTextDocument* script;
};

//Define the singleton type provider function
static QObject* reportGenerator_provider( QQmlEngine* newEngine, QJSEngine* scriptEngine ) {
	Q_UNUSED( scriptEngine )
	
	ReportGenerator* rg = new ReportGenerator( newEngine );
	return rg;
}

#endif // REPORTGENERATOR_H
